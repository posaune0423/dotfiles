#!/bin/sh
# Exercise scripts/raycast-defaults.sh against a throwaway plist so the real
# com.raycast.macos domain is never touched. macOS-only (needs defaults(1)).
set -eu

REPO_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
SCRIPT="$REPO_ROOT/scripts/raycast-defaults.sh"

if [ "$(uname -s 2> /dev/null || echo unknown)" != "Darwin" ]; then
  echo "[skip] defaults(1) is macOS-only"
  exit 0
fi

TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-raycast.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT HUP INT TERM
# defaults(1) takes a file path without the .plist extension.
PLIST="$TEST_ROOT/com.raycast.macos"
PROFILE="$TEST_ROOT/defaults.conf"
export RAYCAST_DEFAULTS_DOMAIN="$PLIST"

fail() {
  echo "[fail] $*" >&2
  exit 1
}

# 1. The tracked profile must parse.
"$SCRIPT" validate > /dev/null || fail "tracked defaults.conf does not validate"

# 2. Broken profiles must be rejected.
printf '%s\n' 'raycastGlobalHotkey string' > "$PROFILE"
if RAYCAST_DEFAULTS_PROFILE="$PROFILE" "$SCRIPT" validate > /dev/null 2>&1; then
  fail "validate accepted a line with a missing value"
fi
printf '%s\n' 'useHyperKeyIcon bool maybe' > "$PROFILE"
if RAYCAST_DEFAULTS_PROFILE="$PROFILE" "$SCRIPT" validate > /dev/null 2>&1; then
  fail "validate accepted a non-boolean bool"
fi
printf '%s\n' 'a string x' 'a string y' > "$PROFILE"
if RAYCAST_DEFAULTS_PROFILE="$PROFILE" "$SCRIPT" validate > /dev/null 2>&1; then
  fail "validate accepted a duplicate key"
fi

# 3. Dry-run must not create the plist; status must report drift on an empty domain.
cat > "$PROFILE" << 'CONF'
raycastGlobalHotkey  string  Control-49
useHyperKeyIcon      bool    false
raycastRetries       int     3
CONF
export RAYCAST_DEFAULTS_PROFILE="$PROFILE"
"$SCRIPT" --dry-run apply > "$TEST_ROOT/dry.out"
[ ! -e "$PLIST.plist" ] || fail "dry-run apply wrote the plist"
grep -q 'defaults write .* raycastGlobalHotkey -string Control-49' "$TEST_ROOT/dry.out" ||
  fail "dry-run did not print the defaults write command"
if "$SCRIPT" status > /dev/null 2>&1; then
  fail "status reported ok before anything was applied"
fi

# 4. Apply, then status must be clean and values must round-trip through defaults(1).
"$SCRIPT" apply > /dev/null
"$SCRIPT" status > "$TEST_ROOT/status.out" || fail "status reported drift after apply"
grep -q '^raycastGlobalHotkey .*Control-49 .*ok$' "$TEST_ROOT/status.out" ||
  fail "status did not show raycastGlobalHotkey as ok"
[ "$(defaults read "$PLIST" useHyperKeyIcon)" = "0" ] || fail "bool false was not written as 0"
[ "$(defaults read-type "$PLIST" raycastRetries)" = "Type is integer" ] || fail "int was not written as integer"

# 5. External drift must be detected, and export-defaults must capture it.
defaults write "$PLIST" raycastGlobalHotkey -string Command-49
if "$SCRIPT" status > /dev/null 2>&1; then
  fail "status missed drift after an external defaults write"
fi
"$SCRIPT" export-defaults "$TEST_ROOT/exported.conf" > /dev/null
grep -q '^raycastGlobalHotkey  *string  *Command-49$' "$TEST_ROOT/exported.conf" ||
  fail "export-defaults did not capture the live value"
grep -q '^useHyperKeyIcon  *bool  *false$' "$TEST_ROOT/exported.conf" ||
  fail "export-defaults did not render bool as true/false"

echo "[ok] raycast-defaults.sh validate/status/apply/export behave in isolation"
