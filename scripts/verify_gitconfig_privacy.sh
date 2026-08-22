#!/bin/sh
set -eu

REPO_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CONFIG="$REPO_ROOT/.gitconfig"
EXPECTED_LOCAL_INCLUDE="~/.gitconfig.local"

actual_local_include="$(git config --file "$CONFIG" --get-all include.path || true)"
if [ "$actual_local_include" != "$EXPECTED_LOCAL_INCLUDE" ]; then
  echo "[fail] .gitconfig must include only $EXPECTED_LOCAL_INCLUDE for machine-private settings" >&2
  exit 1
fi

if git config --file "$CONFIG" --name-only --get-regexp '^includeIf\.' > /dev/null 2>&1; then
  echo "[fail] repository-specific includeIf rules must stay out of tracked .gitconfig" >&2
  exit 1
fi

case "$(git config --file "$CONFIG" --get-regexp '.*')" in
  *'/Users/'* | *'/Private/'* | *'/Work/'*)
    echo "[fail] tracked .gitconfig contains a machine-specific workspace path" >&2
    exit 1
    ;;
esac

echo "[ok] tracked .gitconfig delegates machine-private settings to $EXPECTED_LOCAL_INCLUDE"
