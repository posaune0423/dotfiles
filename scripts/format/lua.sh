#!/bin/sh
set -eu

CHECK_MODE=0
for arg in "$@"; do
  case "$arg" in
    --check) CHECK_MODE=1 ;;
  esac
done

if ! command -v stylua > /dev/null 2>&1; then
  echo "[lua] skip: stylua not found"
  exit 0
fi

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

LIST_FILE="$(mktemp "${TMPDIR:-/tmp}/dotfiles-lua.XXXXXX")"
trap 'rm -f "$LIST_FILE"' EXIT HUP INT TERM

git ls-files -- '*.lua' > "$LIST_FILE" 2> /dev/null || true

COUNT=0
CHANGED=0
SKIPPED=0

echo "[lua] start"
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
    if ! stylua --check "$f" > /dev/null 2>&1; then
      echo "[lua] would reformat: $f"
      CHANGED=$((CHANGED + 1))
    fi
  else
    if ! stylua "$f" > /dev/null 2>&1; then
      echo "[lua] failed: $f"
    fi
  fi
done < "$LIST_FILE"

echo "[lua] summary: processed=$COUNT skipped=$SKIPPED changed=$CHANGED"

if [ "$CHECK_MODE" -eq 1 ] && [ "$CHANGED" -gt 0 ]; then
  exit 1
fi
