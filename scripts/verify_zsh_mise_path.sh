#!/bin/sh
set -eu

REPO_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-zsh-path.XXXXXX")"
TEST_HOME="$TEST_ROOT/home"
TEST_ZDOTDIR="$TEST_ROOT/zdotdir"
MISE_SHIMS="$TEST_HOME/.local/share/mise/shims"
EXPECTED="$MISE_SHIMS/python3"
trap 'rm -rf "$TEST_ROOT"' EXIT HUP INT TERM

mkdir -p "$TEST_HOME/.config" "$MISE_SHIMS" "$TEST_ZDOTDIR"
ln -s "$REPO_ROOT/.config/zsh" "$TEST_HOME/.config/zsh"
ln -s "$REPO_ROOT/.zshenv" "$TEST_ZDOTDIR/.zshenv"
ln -s "$REPO_ROOT/.zprofile" "$TEST_ZDOTDIR/.zprofile"
printf '%s\n' '#!/bin/sh' 'exit 0' > "$EXPECTED"
chmod +x "$EXPECTED"

ACTUAL="$({
  HOME="$TEST_HOME" \
    ZDOTDIR="$TEST_ZDOTDIR" \
    PATH="/usr/local/bin:/usr/bin:/bin:$MISE_SHIMS" \
    /bin/zsh -l -c 'command -v python3'
} 2> /dev/null)"

if [ "$ACTUAL" != "$EXPECTED" ]; then
  echo "[fail] expected $EXPECTED, got $ACTUAL" >&2
  exit 1
fi

echo "[ok] python3 resolves through mise: $ACTUAL"
