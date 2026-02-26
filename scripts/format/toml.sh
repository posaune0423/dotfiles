#!/bin/sh
set -eu

CHECK_MODE=0
for arg in "$@"; do
  case "$arg" in
    --check) CHECK_MODE=1 ;;
  esac
done

if ! command -v taplo > /dev/null 2>&1; then
  echo "[toml] skip: taplo not found"
  exit 0
fi

TAPLO_SUBCOMMAND=""
if taplo format --help > /dev/null 2>&1; then
  TAPLO_SUBCOMMAND="format"
elif taplo fmt --help > /dev/null 2>&1; then
  TAPLO_SUBCOMMAND="fmt"
else
  echo "[toml] skip: unsupported taplo command"
  exit 0
fi

# Some local taplo builds can panic at runtime on macOS.
# Probe a tiny TOML file once and skip TOML formatting if taplo is unusable.
PROBE_FILE="$(mktemp "${TMPDIR:-/tmp}/dotfiles-toml-probe.XXXXXX")"
printf 'x = 1\n' > "$PROBE_FILE"
if ! taplo "$TAPLO_SUBCOMMAND" --check "$PROBE_FILE" > /dev/null 2>&1; then
  rm -f "$PROBE_FILE"
  echo "[toml] skip: taplo runtime is unavailable on this machine"
  exit 0
fi
rm -f "$PROBE_FILE"

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

LIST_FILE="$(mktemp "${TMPDIR:-/tmp}/dotfiles-toml.XXXXXX")"
trap 'rm -f "$LIST_FILE"' EXIT HUP INT TERM

git ls-files -- '*.toml' > "$LIST_FILE" 2> /dev/null || true

COUNT=0
CHANGED=0
SKIPPED=0

echo "[toml] start"
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
    if ! taplo "$TAPLO_SUBCOMMAND" --check "$f" > /dev/null 2>&1; then
      echo "[toml] would reformat: $f"
      CHANGED=$((CHANGED + 1))
    fi
  else
    if ! taplo "$TAPLO_SUBCOMMAND" "$f" > /dev/null 2>&1; then
      echo "[toml] failed: $f"
    fi
  fi
done < "$LIST_FILE"

echo "[toml] summary: processed=$COUNT skipped=$SKIPPED changed=$CHANGED"

if [ "$CHECK_MODE" -eq 1 ] && [ "$CHANGED" -gt 0 ]; then
  exit 1
fi
