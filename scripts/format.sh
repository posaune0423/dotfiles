#!/bin/sh
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FORMAT_DIR="$SCRIPT_DIR/format"

if [ ! -d "$FORMAT_DIR" ]; then
  echo "format script directory not found: $FORMAT_DIR" >&2
  exit 1
fi

SCRIPTS="
$FORMAT_DIR/fish.sh
$FORMAT_DIR/lua.sh
$FORMAT_DIR/toml.sh
$FORMAT_DIR/json.sh
$FORMAT_DIR/shell.sh
"

PIDS=""
FAIL=0

for script in $SCRIPTS; do
  "$script" "$@" &
  PIDS="$PIDS $!"
done

for pid in $PIDS; do
  if ! wait "$pid"; then
    FAIL=1
  fi
done

if [ "$FAIL" -ne 0 ]; then
  echo "format checks failed" >&2
  exit 1
fi

echo "format checks passed"
