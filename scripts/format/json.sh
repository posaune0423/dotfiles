#!/bin/sh
set -eu

CHECK_MODE=0
for arg in "$@"; do
  case "$arg" in
    --check) CHECK_MODE=1 ;;
  esac
done

if ! command -v jq > /dev/null 2>&1; then
  echo "[json] error: jq not found"
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

LIST_FILE="$(mktemp "${TMPDIR:-/tmp}/dotfiles-json.XXXXXX")"
trap 'rm -f "$LIST_FILE"' EXIT HUP INT TERM

git ls-files -- '*.json' > "$LIST_FILE" 2> /dev/null || true

COUNT=0
CHANGED=0
SKIPPED=0

echo "[json] start"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  case "$f" in
    .agents/* | .git/*)
      SKIPPED=$((SKIPPED + 1))
      continue
      ;;
  esac

  COUNT=$((COUNT + 1))
  if [ "$CHECK_MODE" -eq 1 ]; then
    if jq --indent 2 . "$f" 2> /dev/null | diff -q - "$f" > /dev/null 2>&1; then
      :
    else
      if jq --indent 2 . "$f" > /dev/null 2>&1; then
        echo "[json] would reformat: $f"
        CHANGED=$((CHANGED + 1))
      else
        echo "[json] skip invalid json/jsonc: $f"
        SKIPPED=$((SKIPPED + 1))
      fi
    fi
  else
    TMP_JSON="$(mktemp "${TMPDIR:-/tmp}/dotfiles-jsonfmt.XXXXXX")"
    if jq --indent 2 . "$f" > "$TMP_JSON" 2> /dev/null; then
      if ! cat "$TMP_JSON" > "$f" 2> /dev/null; then
        echo "[json] skip write failed: $f"
        SKIPPED=$((SKIPPED + 1))
      fi
    else
      echo "[json] skip invalid json/jsonc: $f"
      SKIPPED=$((SKIPPED + 1))
    fi
    rm -f "$TMP_JSON"
  fi
done < "$LIST_FILE"

echo "[json] summary: processed=$COUNT skipped=$SKIPPED changed=$CHANGED"

if [ "$CHECK_MODE" -eq 1 ] && [ "$CHANGED" -gt 0 ]; then
  exit 1
fi
