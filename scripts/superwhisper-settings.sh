#!/bin/sh
# Superwhisper keeps vocabulary and replacements in a single settings.json, and
# some of those words are private. This builds that file from two sources:
#
#   .config/superwhisper/settings.json        tracked, public entries
#   .config/superwhisper/settings.local.json  untracked, private entries
#
# into .config/superwhisper/settings/settings.json (untracked). The installer
# links the app's settings folder to that directory, so the app reads the
# merged result and writes its own edits back into it.
#
# Every tracked mode in .config/superwhisper/modes/ is registered in modeKeys,
# and build stops a running app first, because the app writes its in-memory
# settings back over a file changed underneath it.
set -eu

REPO_ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
CONFIG_DIR="${SUPERWHISPER_CONFIG_DIR:-$REPO_ROOT/.config/superwhisper}"
PUBLIC="$CONFIG_DIR/settings.json"
LOCAL="$CONFIG_DIR/settings.local.json"
OUT_DIR="$CONFIG_DIR/settings"
OUT="$OUT_DIR/settings.json"
MODES_DIR="$CONFIG_DIR/modes"
# The settings as of the last build (untracked), to tell edits made in the app
# from changes made in the sources.
LAST_BUILD="$CONFIG_DIR/.state/settings.last-build.json"
APP_CTL="${SUPERWHISPER_APP_CTL:-$REPO_ROOT/scripts/superwhisper-app.sh}"

usage() {
  cat << 'EOF'
Usage: superwhisper-settings.sh <command>

  print           Print the merged settings without writing anything
  status          Compare the built settings with the sources (exit 1 on drift)
  build [--force] Write the merged settings. Refuses when the built file holds
                  vocabulary or replacements missing from both sources (added
                  in the app), unless --force is given. A running Superwhisper
                  is quit first and started again afterwards.
EOF
}

die() {
  echo "superwhisper-settings: $*" >&2
  exit 1
}

command -v jq > /dev/null 2>&1 || die "jq not found"

app() {
  sh "$APP_CTL" "$@"
}

# Keys of the tracked modes. system-* modes are built into the app and are not
# listed in modeKeys.
mode_keys() {
  set -- "$MODES_DIR"/*.json
  if [ -f "$1" ]; then
    jq -s '[.[] | .key | strings | select(startswith("system-") | not)]' "$@"
  else
    echo '[]'
  fi
}

# Private entries are appended to the public ones. A private replacement with
# the same "original" replaces the public one; other private keys override.
# Tracked modes missing from modeKeys are appended, or the app never loads them.
merge() {
  [ -f "$PUBLIC" ] || die "missing $PUBLIC"
  modes="$(mode_keys)"
  if [ -f "$LOCAL" ]; then
    set -- "$PUBLIC" "$LOCAL"
  else
    set -- "$PUBLIC"
  fi
  jq -s --argjson modes "$modes" '
    .[0] as $p | (.[1] // {}) as $l
    | ($p + $l)
    | .vocabulary = (
        reduce (($p.vocabulary // []) + ($l.vocabulary // []))[] as $v
          ([]; if any(.[]; . == $v) then . else . + [$v] end)
      )
    | .replacements = (
        [($p.replacements // [])[]
          | select(.original as $o | all(($l.replacements // [])[]; .original != $o))]
        + ($l.replacements // [])
      )
    | if .modeKeys == null and ($modes | length) == 0 then .
      else .modeKeys = (
        reduce ((.modeKeys // []) + $modes)[] as $k
          ([]; if any(.[]; . == $k) then . else . + [$k] end)
      )
      end
  ' "$@"
}

# Order and replacement ids carry no meaning, so drop them before comparing.
normalize() {
  jq -S '
    .vocabulary = ((.vocabulary // []) | sort)
    | .replacements = ([(.replacements // [])[] | {original, with}] | sort_by(.original))
  ' "$1"
}

# Entries present in the built file ($1) but in neither reference: $2 is the
# merge or the last build, $3 the public file (or the last build again):
# vocabulary, replacements, mode registrations, and any other setting whose
# value differs (such as favorite models changed in the app). The public file is
# checked as well as the merge, because a private replacement hides the public
# one it overrides.
app_side_entries() {
  jq -rn --slurpfile cur "$1" --slurpfile new "$2" --slurpfile pub "${3:-$PUBLIC}" '
    $cur[0] as $c
    | (($new[0].vocabulary // []) + ($pub[0].vocabulary // [])) as $words
    | [(($new[0].replacements // []) + ($pub[0].replacements // []))[] | {original, with}] as $rules
    | (($c.vocabulary // [])[]
        | select(. as $v | any($words[]; . == $v) | not)
        | "vocabulary: \(.)"),
      (($c.replacements // [])[]
        | select({original, with} as $r | any($rules[]; . == $r) | not)
        | "replacement: \(.original) -> \(.with)"),
      (($c.modeKeys // [])[]
        | select(. as $k | any(($new[0].modeKeys // [])[]; . == $k) | not)
        | "modeKeys: \(.)"),
      ($c | keys_unsorted[]
        | select(IN("vocabulary", "replacements", "modeKeys") | not)
        | select($c[.] != $new[0][.])
        | "setting: \(.)")
  '
}

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/superwhisper-settings.XXXXXX")"
TMP_OUT=""
APP_STOPPED=0
# Runs on every exit, including a refused build, so a stopped app always
# comes back.
cleanup() {
  rm -rf "$TMP_DIR"
  if [ -n "$TMP_OUT" ]; then
    rm -f "$TMP_OUT"
  fi
  if [ "$APP_STOPPED" -eq 1 ]; then
    app launch || echo "superwhisper-settings: could not start Superwhisper again" >&2
  fi
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM
MERGED="$TMP_DIR/merged.json"

cmd="${1:-}"
[ $# -gt 0 ] && shift

case "$cmd" in
  print)
    merge
    ;;
  status)
    [ -f "$OUT" ] || die "not built yet: run 'superwhisper-settings.sh build'"
    merge > "$MERGED"
    normalize "$MERGED" > "$TMP_DIR/sources.json"
    normalize "$OUT" > "$TMP_DIR/built.json"
    if diff -u "$TMP_DIR/sources.json" "$TMP_DIR/built.json"; then
      echo "superwhisper-settings: in sync"
    else
      echo "superwhisper-settings: built settings differ from the sources (- sources, + built)" >&2
      exit 1
    fi
    ;;
  build)
    FORCE=0
    for arg in "$@"; do
      case "$arg" in
        --force) FORCE=1 ;;
        *) die "unknown option: $arg" ;;
      esac
    done
    # Quit before reading the built file: the app saves its settings as it
    # quits, and anything it wrote while running would replace this build.
    if app running; then
      echo "superwhisper-settings: quitting Superwhisper during the build"
      app quit || die "could not quit Superwhisper; quit it and rerun"
      APP_STOPPED=1
    fi
    merge > "$MERGED"
    # Check a snapshot, then make sure the app did not write in between.
    SNAPSHOT="$TMP_DIR/built.json"
    if [ -f "$OUT" ] && [ "$FORCE" -eq 0 ]; then
      cp "$OUT" "$SNAPSHOT"
      # Compare with the last build when there is one, so that a change made
      # only in the sources (a removed word, new favorites) is not refused.
      if [ -f "$LAST_BUILD" ]; then
        extra="$(app_side_entries "$SNAPSHOT" "$LAST_BUILD" "$LAST_BUILD")"
      else
        extra="$(app_side_entries "$SNAPSHOT" "$MERGED")"
      fi
      if [ -n "$extra" ]; then
        echo "superwhisper-settings: the built file has entries missing from both sources:" >&2
        printf '%s\n' "$extra" | sed 's/^/  /' >&2
        echo "Move them into settings.json or settings.local.json (pull modes first for modeKeys), or rerun with --force to drop them." >&2
        exit 1
      fi
    fi
    mkdir -p "$OUT_DIR"
    # Rename within the folder so the app never reads a half-written file. The
    # temporary name is unique, so overlapping builds cannot share it.
    TMP_OUT="$(mktemp "$OUT_DIR/.settings.json.XXXXXX")"
    cp "$MERGED" "$TMP_OUT"
    chmod 644 "$TMP_OUT"
    if [ -f "$SNAPSHOT" ] && ! cmp -s "$SNAPSHOT" "$OUT"; then
      die "the built settings changed during the build (edited in the app?): rerun"
    fi
    mv "$TMP_OUT" "$OUT"
    mkdir -p "$(dirname "$LAST_BUILD")"
    cp "$MERGED" "$LAST_BUILD"
    TMP_OUT=""
    echo "superwhisper-settings: wrote $OUT"
    ;;
  -h | --help | help)
    usage
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
