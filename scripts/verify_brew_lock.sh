#!/bin/sh
# Exercise scripts/brew-lock.sh against a stub `brew`, so the lock contract
# (drift detection, pinning, bumping) is checked without touching Homebrew.
set -eu

REPO_ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
BREW_LOCK="$REPO_ROOT/scripts/brew-lock.sh"
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-brew-lock.XXXXXX")"
trap 'rm -rf "$WORK_DIR"' EXIT HUP INT TERM

STUB_STATE="$WORK_DIR/state"
BREW_LOCKFILE="$WORK_DIR/Brewfile.lock"
export STUB_STATE BREW_LOCKFILE
mkdir -p "$WORK_DIR/bin" "$STUB_STATE/versions" "$STUB_STATE/pinned" "$STUB_STATE/latest"

# Installed, pinned, and upstream versions live as files under $STUB_STATE.
cat > "$WORK_DIR/bin/brew" << 'EOF'
#!/bin/sh
for _arg in "$@"; do _name="$_arg"; done
case "$1 ${2:-}" in
  "list --versions")
    [ -f "$STUB_STATE/versions/$_name" ] || exit 1
    echo "$_name $(cat "$STUB_STATE/versions/$_name")"
    ;;
  "list --pinned") ls "$STUB_STATE/pinned" ;;
  "pin "*)
    [ -f "$STUB_STATE/versions/$_name" ] || exit 1
    : > "$STUB_STATE/pinned/$_name"
    ;;
  "unpin "*) rm -f "$STUB_STATE/pinned/$_name" ;;
  "upgrade "* | "install "*)
    # Homebrew leaves a pinned formula at its installed version.
    [ -f "$STUB_STATE/pinned/$_name" ] || cp "$STUB_STATE/latest/$_name" "$STUB_STATE/versions/$_name"
    ;;
  *)
    echo "stub brew: unexpected $*" >&2
    exit 2
    ;;
esac
EOF
chmod +x "$WORK_DIR/bin/brew"
PATH="$WORK_DIR/bin:$PATH"
export PATH

FAIL=0

expect_status() {
  _label="$1"
  _want="$2"
  shift 2
  _got=0
  "$@" > "$WORK_DIR/out" 2>&1 || _got=$?
  if [ "$_got" -ne "$_want" ]; then
    echo "[fail] $_label: exit $_got, want $_want" >&2
    sed 's/^/  /' "$WORK_DIR/out" >&2
    FAIL=1
  fi
}

expect_output() {
  _label="$1"
  _pattern="$2"
  if ! grep -q "$_pattern" "$WORK_DIR/out"; then
    echo "[fail] $_label: output lacks '$_pattern'" >&2
    sed 's/^/  /' "$WORK_DIR/out" >&2
    FAIL=1
  fi
}

reset_state() {
  rm -f "$STUB_STATE"/versions/* "$STUB_STATE"/pinned/* "$STUB_STATE"/latest/*
  printf '# held versions\ndemo 1.2.3\n' > "$BREW_LOCKFILE"
}

reset_state
expect_status "check: not installed" 1 sh "$BREW_LOCK" check
expect_output "check: not installed" "demo: not installed"

reset_state
echo 1.2.3 > "$STUB_STATE/versions/demo"
expect_status "check: installed but unpinned" 1 sh "$BREW_LOCK" check
expect_output "check: installed but unpinned" "not pinned"
expect_status "pin: matching version" 0 sh "$BREW_LOCK" pin
expect_status "check: pinned at locked version" 0 sh "$BREW_LOCK" check

reset_state
echo 1.3.0 > "$STUB_STATE/versions/demo"
expect_status "check: version drift" 1 sh "$BREW_LOCK" check
expect_output "check: version drift" "installed 1.3.0, locked 1.2.3"
expect_status "pin: version drift" 1 sh "$BREW_LOCK" pin
if [ -e "$STUB_STATE/pinned/demo" ]; then
  echo "[fail] pin: pinned a version that differs from the lock" >&2
  FAIL=1
fi

reset_state
echo 1.2.3 > "$STUB_STATE/versions/demo"
echo 1.4.0 > "$STUB_STATE/latest/demo"
: > "$STUB_STATE/pinned/demo"
expect_status "bump: pinned formula" 0 sh "$BREW_LOCK" bump demo
if [ "$(cat "$BREW_LOCKFILE")" != "$(printf '# held versions\ndemo 1.4.0\n')" ]; then
  echo "[fail] bump: lock file is not '# held versions' + 'demo 1.4.0':" >&2
  sed 's/^/  /' "$BREW_LOCKFILE" >&2
  FAIL=1
fi
expect_status "check: after bump" 0 sh "$BREW_LOCK" check

expect_status "bump: formula missing from the lock" 1 sh "$BREW_LOCK" bump other
expect_status "unknown subcommand" 2 sh "$BREW_LOCK" frobnicate

if [ "$FAIL" -ne 0 ]; then
  exit 1
fi

echo "[ok] brew-lock.sh detects drift, pins matching versions, and records bumps"
