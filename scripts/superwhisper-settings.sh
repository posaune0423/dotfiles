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
set -eu

REPO_ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
CONFIG_DIR="${SUPERWHISPER_CONFIG_DIR:-$REPO_ROOT/.config/superwhisper}"
PUBLIC="$CONFIG_DIR/settings.json"
LOCAL="$CONFIG_DIR/settings.local.json"
OUT_DIR="$CONFIG_DIR/settings"
OUT="$OUT_DIR/settings.json"

usage() {
  cat << 'EOF'
Usage: superwhisper-settings.sh <command>

  print           Print the merged settings without writing anything
  status          Compare the built settings with the sources (exit 1 on drift)
  build [--force] Write the merged settings. Refuses when the built file holds
                  vocabulary or replacements missing from both sources (added
                  in the app), unless --force is given.
EOF
}

die() {
  echo "superwhisper-settings: $*" >&2
  exit 1
}

command -v jq > /dev/null 2>&1 || die "jq not found"

# Private entries are appended to the public ones. A private replacement with
# the same "original" replaces the public one; other private keys override.
merge() {
  [ -f "$PUBLIC" ] || die "missing $PUBLIC"
  if [ -f "$LOCAL" ]; then
    set -- "$PUBLIC" "$LOCAL"
  else
    set -- "$PUBLIC"
  fi
  jq -s '
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
  ' "$@"
}

# Order and replacement ids carry no meaning, so drop them before comparing.
normalize() {
  jq -S '
    .vocabulary = ((.vocabulary // []) | sort)
    | .replacements = ([(.replacements // [])[] | {original, with}] | sort_by(.original))
  ' "$1"
}

# Entries present in the built file but in neither source. The public file is
# checked as well as the merge, because a private replacement hides the public
# one it overrides.
app_side_entries() {
  jq -rn --slurpfile cur "$OUT" --slurpfile new "$1" --slurpfile pub "$PUBLIC" '
    $cur[0] as $c
    | (($new[0].vocabulary // []) + ($pub[0].vocabulary // [])) as $words
    | [(($new[0].replacements // []) + ($pub[0].replacements // []))[] | {original, with}] as $rules
    | (($c.vocabulary // [])[]
        | select(. as $v | any($words[]; . == $v) | not)
        | "vocabulary: \(.)"),
      (($c.replacements // [])[]
        | select({original, with} as $r | any($rules[]; . == $r) | not)
        | "replacement: \(.original) -> \(.with)")
  '
}

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/superwhisper-settings.XXXXXX")"
trap 'rm -rf "$TMP_DIR"' EXIT HUP INT TERM
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
    merge > "$MERGED"
    if [ -f "$OUT" ] && [ "$FORCE" -eq 0 ]; then
      extra="$(app_side_entries "$MERGED")"
      if [ -n "$extra" ]; then
        echo "superwhisper-settings: the built file has entries missing from both sources:" >&2
        printf '%s\n' "$extra" | sed 's/^/  /' >&2
        echo "Move them into settings.json or settings.local.json, or rerun with --force to drop them." >&2
        exit 1
      fi
    fi
    mkdir -p "$OUT_DIR"
    # Rename within the folder so the app never reads a half-written file.
    cp "$MERGED" "$OUT_DIR/.settings.json.tmp"
    mv "$OUT_DIR/.settings.json.tmp" "$OUT"
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
