#!/bin/sh
set -eu

REPO_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CONFIG="$REPO_ROOT/.gitconfig"
EXPECTED_LOCAL_INCLUDE="~/.gitconfig.local"
EXPECTED_USER_NAME="posaune0423"
EXPECTED_USER_EMAIL="posaune0423@users.noreply.github.com"

actual_local_include="$(git config --file "$CONFIG" --get-all include.path || true)"
if [ "$actual_local_include" != "$EXPECTED_LOCAL_INCLUDE" ]; then
  echo "[fail] .gitconfig must include only $EXPECTED_LOCAL_INCLUDE for machine-private settings" >&2
  exit 1
fi

if git config --file "$CONFIG" --name-only --get-regexp '^includeIf\.' > /dev/null 2>&1; then
  echo "[fail] repository-specific includeIf rules must stay out of tracked .gitconfig" >&2
  exit 1
fi

if git config --file "$CONFIG" --name-only --get-regexp '^coderabbit\.machineid$' > /dev/null 2>&1; then
  echo "[fail] CodeRabbit machine identity must stay out of tracked .gitconfig" >&2
  exit 1
fi

# The author identity is tracked, so a personal, corporate, or hostname-derived
# mailbox can only reach a commit by being written here first.
actual_user_name="$(git config --file "$CONFIG" --get user.name || true)"
if [ "$actual_user_name" != "$EXPECTED_USER_NAME" ]; then
  echo "[fail] .gitconfig user.name must be $EXPECTED_USER_NAME (got: ${actual_user_name:-unset})" >&2
  exit 1
fi

actual_user_email="$(git config --file "$CONFIG" --get user.email || true)"
if [ "$actual_user_email" != "$EXPECTED_USER_EMAIL" ]; then
  echo "[fail] .gitconfig user.email must be $EXPECTED_USER_EMAIL (got: ${actual_user_email:-unset})" >&2
  exit 1
fi

case "$(git config --file "$CONFIG" --get-regexp '.*')" in
  *'/Users/'* | *'/Private/'* | *'/Work/'*)
    echo "[fail] tracked .gitconfig contains a machine-specific workspace path" >&2
    exit 1
    ;;
esac

echo "[ok] tracked .gitconfig delegates machine-private settings to $EXPECTED_LOCAL_INCLUDE"
echo "[ok] tracked .gitconfig authors as $EXPECTED_USER_NAME <$EXPECTED_USER_EMAIL>"
