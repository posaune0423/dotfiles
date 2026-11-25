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
set -eu

REPO_ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
CONFIG_DIR="${SUPERWHISPER_CONFIG_DIR:-$REPO_ROOT/.config/superwhisper}"
REPO_MODES="$CONFIG_DIR/modes"
APP_DIR="${SUPERWHISPER_APP_DIR:-$HOME/Documents/superwhisper}"
APP_MODES="$APP_DIR/modes"
APP_CTL="${SUPERWHISPER_APP_CTL:-$REPO_ROOT/scripts/superwhisper-app.sh}"

usage() {
  cat << 'EOF'
Usage: superwhisper-modes.sh <command>

  status         Compare the app's modes with the repository (exit 1 on drift)
  push [--force] Copy the repository modes into the app folder. Refuses when
                 the app holds modes changed or added in the app, unless
                 --force is given. A running Superwhisper is quit first and
                 started again afterwards.
  pull           Copy the app's modes into the repository, including modes
                 added or deleted in the app
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

# One line per difference, from the app's point of view:
#   changed: <name>   both have it with different content
#   added: <name>     only the app has it
#   missing: <name>   only the repository has it
differences() {
  {
    mode_names "$REPO_MODES"
    if app_modes_is_folder; then mode_names "$APP_MODES"; fi
  } | sort -u | while IFS= read -r name; do
    if [ ! -f "$APP_MODES/$name" ] || ! app_modes_is_folder; then
      echo "missing: $name"
    elif [ ! -f "$REPO_MODES/$name" ]; then
      echo "added: $name"
    elif ! same_json "$REPO_MODES/$name" "$APP_MODES/$name"; then
      echo "changed: $name"
    fi
  done
}

TMP_DIR=""
APP_STOPPED=0
cleanup() {
  if [ -n "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
  fi
  if [ "$APP_STOPPED" -eq 1 ]; then
    app launch || echo "superwhisper-modes: could not start Superwhisper again" >&2
  fi
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

cmd="${1:-}"
[ $# -gt 0 ] && shift

case "$cmd" in
  status)
    [ -d "$REPO_MODES" ] || die "missing $REPO_MODES"
    if [ -L "$APP_MODES" ]; then
      echo "superwhisper-modes: $APP_MODES is a symlink, which the app cannot list: run push" >&2
      exit 1
    fi
    diff_out="$(differences)"
    if [ -n "$diff_out" ]; then
      echo "superwhisper-modes: the app's modes differ from the repository:" >&2
      printf '%s\n' "$diff_out" | sed 's/^/  /' >&2
      exit 1
    fi
    echo "superwhisper-modes: in sync"
    ;;
  push)
    FORCE=0
    for arg in "$@"; do
      case "$arg" in
        --force) FORCE=1 ;;
        *) die "unknown option: $arg" ;;
      esac
    done
    [ -d "$REPO_MODES" ] || die "missing $REPO_MODES"
    [ -d "$APP_DIR" ] || die "missing $APP_DIR (is Superwhisper installed?)"
    # Quit before comparing: the app saves its modes as it quits.
    if app running; then
      echo "superwhisper-modes: quitting Superwhisper during the copy"
      app quit || die "could not quit Superwhisper; quit it and rerun"
      APP_STOPPED=1
    fi
    if [ "$FORCE" -eq 0 ] && app_modes_is_folder; then
      app_side="$(differences | grep -E '^(changed|added): ' || true)"
      if [ -n "$app_side" ]; then
        echo "superwhisper-modes: the app has modes that differ from the repository:" >&2
        printf '%s\n' "$app_side" | sed 's/^/  /' >&2
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
    echo "superwhisper-modes: copied $(mode_names "$APP_MODES" | wc -l | tr -d ' ') modes into $APP_MODES"
    ;;
  pull)
    app_modes_is_folder || die "$APP_MODES is not a folder: run push first"
    mkdir -p "$REPO_MODES"
    changes="$(differences)"
    if [ -z "$changes" ]; then
      echo "superwhisper-modes: nothing to pull"
      exit 0
    fi
    printf '%s\n' "$changes" | while IFS= read -r line; do
      name="${line#*: }"
      case "$line" in
        missing:*) rm -f "$REPO_MODES/$name" ;;
        *) cp "$APP_MODES/$name" "$REPO_MODES/$name" ;;
      esac
    done
    echo "superwhisper-modes: pulled into $REPO_MODES:"
    printf '%s\n' "$changes" | sed -e 's/^missing:/deleted:/' -e 's/^/  /'
    ;;
  -h | --help | help)
    usage
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
