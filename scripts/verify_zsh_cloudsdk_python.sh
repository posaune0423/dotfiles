#!/bin/sh
# gcloud must run on mise's latest Python and gsutil on mise's 3.14 line, even
# when the shell inherits a stale interpreter path (launchctl, parent shells).
set -eu

REPO_ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-cloudsdk.XXXXXX")"
TEST_HOME="$TEST_ROOT/home"
TEST_ZDOTDIR="$TEST_ROOT/zdotdir"
PYTHONS="$TEST_HOME/.local/share/mise/installs/python"
trap 'rm -rf "$TEST_ROOT"' EXIT HUP INT TERM

mkdir -p "$PYTHONS/latest/bin" "$PYTHONS/3.14/bin" "$TEST_ZDOTDIR" "$TEST_ROOT/custom"
for py in "$PYTHONS/latest/bin/python3" "$PYTHONS/3.14/bin/python3" "$TEST_ROOT/custom/python3"; do
  printf '%s\n' '#!/bin/sh' 'exit 0' > "$py"
  chmod +x "$py"
done
ln -s "$REPO_ROOT/.zshenv" "$TEST_ZDOTDIR/.zshenv"

# Prints "CLOUDSDK_PYTHON|CLOUDSDK_GSUTIL_PYTHON" after .zshenv runs.
# shellcheck disable=SC2016 # the variables must expand inside zsh, not here
resolve() {
  env -u CLOUDSDK_PYTHON -u CLOUDSDK_GSUTIL_PYTHON "$@" \
    HOME="$TEST_HOME" ZDOTDIR="$TEST_ZDOTDIR" PATH="/usr/bin:/bin" \
    /bin/zsh -c 'print -r -- "$CLOUDSDK_PYTHON|$CLOUDSDK_GSUTIL_PYTHON"' 2> /dev/null
}

FAIL=0
expect() {
  if [ "$2" != "$3" ]; then
    echo "[fail] $1: expected $3, got $2" >&2
    FAIL=1
  else
    echo "[ok] $1"
  fi
}

DEFAULT="$PYTHONS/latest/bin/python3|$PYTHONS/3.14/bin/python3"
expect "unset" "$(resolve)" "$DEFAULT"
expect "stale inherited paths are replaced" \
  "$(resolve CLOUDSDK_PYTHON=/nonexistent/python3.13 CLOUDSDK_GSUTIL_PYTHON=/nonexistent/python3.13)" \
  "$DEFAULT"
expect "working inherited paths are kept" \
  "$(resolve CLOUDSDK_PYTHON="$TEST_ROOT/custom/python3" CLOUDSDK_GSUTIL_PYTHON="$TEST_ROOT/custom/python3")" \
  "$TEST_ROOT/custom/python3|$TEST_ROOT/custom/python3"

exit "$FAIL"
