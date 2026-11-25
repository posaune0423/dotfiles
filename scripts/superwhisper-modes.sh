#!/bin/sh
# Keep Superwhisper's modes in the repository without linking the folder.
#
# Superwhisper lists <app folder>/modes with URL-based Foundation APIs, which
# do not follow a symlinked folder: a linked modes/ looks empty to the app. So
# the app folder keeps a real modes/ holding copies of the tracked modes:
#
#   .config/superwhisper/modes/*.json   tracked, the source of truth
#   ~/Documents/superwhisper/modes/     real folder the app reads and edits
#
# push copies the repository into the app folder, pull copies edits made in
# the app back into the repository, and status compares the two. JSON layout
# is ignored, because the app saves in its own layout.
#
# The modes as of the last push or pull are kept in .config/superwhisper/.state
# (untracked), so an edit made in the repository is never mistaken for an
# edit made in the app, and the reverse.
set -eu

REPO_ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
CONFIG_DIR="${SUPERWHISPER_CONFIG_DIR:-$REPO_ROOT/.config/superwhisper}"
REPO_MODES="$CONFIG_DIR/modes"
STATE_DIR="$CONFIG_DIR/.state"
BASE="$STATE_DIR/modes-base"
LOCK="$STATE_DIR/modes.lock"
APP_DIR="${SUPERWHISPER_APP_DIR:-$HOME/Documents/superwhisper}"
APP_MODES="$APP_DIR/modes"
APP_CTL="${SUPERWHISPER_APP_CTL:-$REPO_ROOT/scripts/superwhisper-app.sh}"

usage() {
  cat << 'EOF'
Usage: superwhisper-modes.sh <command>

  status                 Compare the app's modes with the repository, naming
                         the side of each change (exit 1 on drift)
  push [--force|--check] Copy the repository modes into the app folder.
                         Refuses when modes were changed, added, or deleted in
                         the app since the last sync, unless --force is given.
                         --check only reports whether push would refuse. A
                         running Superwhisper is quit first and started again.
  pull                   Copy modes changed, added, or deleted in the app into
                         the repository. Refuses when the repository changed
                         the same mode since the last sync.
EOF
}

die() {
  echo "superwhisper-modes: $*" >&2
  exit 1
}

command -v jq > /dev/null 2>&1 || die "jq not found"

app() {
  sh "$APP_CTL" "$@"
}

# The app folder's modes/ must be a real folder for the app to list it.
app_modes_is_folder() {
  [ -d "$APP_MODES" ] && [ ! -L "$APP_MODES" ]
}

mode_names() {
  for f in "$1"/*.json; do
    [ -f "$f" ] && basename "$f"
  done
  return 0
}

same_json() {
  [ "$(jq -cS . "$1" 2> /dev/null)" = "$(jq -cS . "$2" 2> /dev/null)" ]
}

# Changes in folder $1 relative to folder $2, one per line:
#   changed: <name> | added: <name> (only in $1) | deleted: <name> (only in $2)
changes() {
  {
    mode_names "$1"
    mode_names "$2"
  } | sort -u | while IFS= read -r name; do
    if [ ! -f "$2/$name" ]; then
      echo "added: $name"
    elif [ ! -f "$1/$name" ]; then
      echo "deleted: $name"
    elif ! same_json "$1/$name" "$2/$name"; then
      echo "changed: $name"
    fi
  done
}

# Changes made in the app since the last sync. Without a record of the last
# sync, anything the app has that the repository lacks or differs on counts.
app_changes() {
  app_modes_is_folder || return 0
  if [ -d "$BASE" ]; then
    changes "$APP_MODES" "$BASE"
  else
    changes "$APP_MODES" "$REPO_MODES" | grep -v '^deleted: ' || true
  fi
}

# Changes made in the repository since the last sync.
repo_changes() {
  if [ -d "$BASE" ]; then
    changes "$REPO_MODES" "$BASE"
  fi
}

# Record folder $1 as the modes as of this sync.
record_sync() {
  mkdir -p "$STATE_DIR"
  rm -rf "$BASE.new"
  mkdir "$BASE.new"
  for name in $(mode_names "$1"); do
    cp "$1/$name" "$BASE.new/$name"
  done
  rm -rf "$BASE"
  mv "$BASE.new" "$BASE"
}

TMP_DIR=""
LOCKED=0
APP_STOPPED=0
cleanup() {
  if [ -n "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
  fi
  if [ "$LOCKED" -eq 1 ]; then
    rmdir "$LOCK" 2> /dev/null || true
  fi
  if [ "$APP_STOPPED" -eq 1 ]; then
    app launch || echo "superwhisper-modes: could not start Superwhisper again" >&2
  fi
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

# push and pull both move files between the two folders; never overlap them.
take_lock() {
  mkdir -p "$STATE_DIR"
  mkdir "$LOCK" 2> /dev/null ||
    die "another push or pull is running (remove $LOCK if it is stale)"
  LOCKED=1
}

print_changes() {
  sed "s/^/  $1: /"
}

cmd="${1:-}"
[ $# -gt 0 ] && shift

case "$cmd" in
  status)
    [ -d "$REPO_MODES" ] || die "missing $REPO_MODES"
    if [ -L "$APP_MODES" ]; then
      echo "superwhisper-modes: $APP_MODES is a symlink, which the app cannot list: run push" >&2
      exit 1
    fi
    if app_modes_is_folder && [ -z "$(changes "$APP_MODES" "$REPO_MODES")" ]; then
      echo "superwhisper-modes: in sync"
      exit 0
    fi
    echo "superwhisper-modes: the app's modes differ from the repository:" >&2
    if ! app_modes_is_folder; then
      echo "  app: no modes folder: run push" >&2
    elif [ -d "$BASE" ]; then
      app_changes | print_changes app >&2
      repo_changes | print_changes repo >&2
    else
      changes "$APP_MODES" "$REPO_MODES" | print_changes app >&2
    fi
    exit 1
    ;;
  push)
    FORCE=0
    CHECK=0
    for arg in "$@"; do
      case "$arg" in
        --force) FORCE=1 ;;
        --check) CHECK=1 ;;
        *) die "unknown option: $arg" ;;
      esac
    done
    [ -d "$REPO_MODES" ] || die "missing $REPO_MODES"
    if [ "$CHECK" -eq 1 ]; then
      app_side="$(app_changes)"
      if [ -n "$app_side" ]; then
        printf '%s\n' "$app_side" | print_changes app
        exit 1
      fi
      exit 0
    fi
    [ -d "$APP_DIR" ] || die "missing $APP_DIR (is Superwhisper installed?)"
    take_lock
    # Quit before comparing: the app saves its modes as it quits.
    if app running; then
      echo "superwhisper-modes: quitting Superwhisper during the copy"
      app quit || die "could not quit Superwhisper; quit it and rerun"
      APP_STOPPED=1
    fi
    if [ "$FORCE" -eq 0 ]; then
      app_side="$(app_changes)"
      if [ -n "$app_side" ]; then
        echo "superwhisper-modes: modes were edited in the app since the last sync:" >&2
        printf '%s\n' "$app_side" | print_changes app >&2
        echo "Run 'superwhisper-modes.sh pull' to keep them, or 'push --force' to drop them." >&2
        exit 1
      fi
    fi
    # Stage the copy next to the target, then swap it in with renames.
    TMP_DIR="$(mktemp -d "$APP_DIR/.modes.XXXXXX")"
    mkdir "$TMP_DIR/new"
    for name in $(mode_names "$REPO_MODES"); do
      cp "$REPO_MODES/$name" "$TMP_DIR/new/$name"
      chmod 644 "$TMP_DIR/new/$name"
    done
    if [ -L "$APP_MODES" ]; then
      rm "$APP_MODES"
    elif [ -e "$APP_MODES" ]; then
      mv "$APP_MODES" "$TMP_DIR/old"
    fi
    mv "$TMP_DIR/new" "$APP_MODES"
    record_sync "$APP_MODES"
    echo "superwhisper-modes: copied $(mode_names "$APP_MODES" | wc -l | tr -d ' ') modes into $APP_MODES"
    ;;
  pull)
    [ $# -eq 0 ] || die "unknown option: $1"
    app_modes_is_folder || die "$APP_MODES is not a folder: run push first"
    mkdir -p "$REPO_MODES"
    take_lock
    if [ -d "$BASE" ]; then
      app_side="$(app_changes)"
      repo_side="$(repo_changes)"
      repo_names="$(printf '%s\n' "$repo_side" | sed 's/^[a-z]*: //')"
      both=""
      for name in $(printf '%s\n' "$app_side" | sed 's/^[a-z]*: //'); do
        if printf '%s\n' "$repo_names" | grep -Fqx "$name"; then
          both="${both}${name}
"
        fi
      done
      both="$(printf '%s' "$both")"
    else
      app_side="$(changes "$APP_MODES" "$REPO_MODES")"
      both=""
    fi
    if [ -n "$both" ]; then
      echo "superwhisper-modes: these modes changed in both the app and the repository:" >&2
      printf '%s\n' "$both" | sed 's/^/  /' >&2
      echo "Keep one side: 'push --force' (repository) or copy the app's file by hand." >&2
      exit 1
    fi
    if [ -n "$app_side" ]; then
      printf '%s\n' "$app_side" | while IFS= read -r line; do
        name="${line#*: }"
        case "$line" in
          deleted:*) rm -f "$REPO_MODES/$name" ;;
          *) cp "$APP_MODES/$name" "$REPO_MODES/$name" ;;
        esac
      done
    fi
    record_sync "$APP_MODES"
    if [ -z "$app_side" ]; then
      echo "superwhisper-modes: nothing to pull"
    else
      echo "superwhisper-modes: pulled into $REPO_MODES:"
      printf '%s\n' "$app_side" | sed 's/^/  /'
    fi
    ;;
  -h | --help | help)
    usage
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
