#!/bin/sh
set -eu

CHECK_MODE=0
for arg in "$@"; do
  case "$arg" in
    --check) CHECK_MODE=1 ;;
  esac
done

if ! command -v shfmt > /dev/null 2>&1; then
  echo "[shell] error: shfmt not found"
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

LIST_FILE="$(mktemp "${TMPDIR:-/tmp}/dotfiles-shell.XXXXXX")"
trap 'rm -f "$LIST_FILE"' EXIT HUP INT TERM

git ls-files -- '*.sh' '.zshrc' '.zshenv' '.zprofile' '.config/zsh/*.zsh' > "$LIST_FILE" 2> /dev/null || true

COUNT=0
CHANGED=0
SKIPPED=0

echo "[shell] start"
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
    if ! shfmt -i 2 -ci -sr "$f" 2> /dev/null | diff -q - "$f" > /dev/null 2>&1; then
      if shfmt -i 2 -ci -sr "$f" > /dev/null 2>&1; then
        echo "[shell] would reformat: $f"
        CHANGED=$((CHANGED + 1))
      else
        echo "[shell] skip parse error: $f"
        SKIPPED=$((SKIPPED + 1))
      fi
    fi
  else
    if ! shfmt -i 2 -ci -sr -w "$f" 2> /dev/null; then
      echo "[shell] skip parse error: $f"
      SKIPPED=$((SKIPPED + 1))
    fi
  fi
done < "$LIST_FILE"

echo "[shell] summary: processed=$COUNT skipped=$SKIPPED changed=$CHANGED"

if [ "$CHECK_MODE" -eq 1 ] && [ "$CHANGED" -gt 0 ]; then
  exit 1
fi
