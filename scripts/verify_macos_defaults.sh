#!/bin/sh
# Exercise scripts/macos-defaults.sh against a throwaway plist so NSGlobalDomain
# is never touched. macOS-only (needs defaults(1)).
set -eu

REPO_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
SCRIPT="$REPO_ROOT/scripts/macos-defaults.sh"

if [ "$(uname -s 2> /dev/null || echo unknown)" != "Darwin" ]; then
  echo "[skip] defaults(1) is macOS-only"
  exit 0
fi

TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-macos-defaults.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT HUP INT TERM
# defaults(1) takes a file path without the .plist extension.
PLIST="$TEST_ROOT/fake.domain"
OTHER_PLIST="$TEST_ROOT/fake.other"
PROFILE="$TEST_ROOT/defaults.conf"

fail() {
  echo "[fail] $*" >&2
  exit 1
}

# 1. The tracked profile must parse.
"$SCRIPT" validate > /dev/null || fail "tracked defaults.conf does not validate"

# 2. Broken profiles must be rejected.
printf '%s\n' 'NSGlobalDomain KeyRepeat int' > "$PROFILE"
if MACOS_DEFAULTS_PROFILE="$PROFILE" "$SCRIPT" validate > /dev/null 2>&1; then
  fail "validate accepted a line with a missing value"
fi
printf '%s\n' 'NSGlobalDomain ApplePressAndHoldEnabled bool maybe' > "$PROFILE"
if MACOS_DEFAULTS_PROFILE="$PROFILE" "$SCRIPT" validate > /dev/null 2>&1; then
  fail "validate accepted a non-boolean bool"
fi
printf '%s\n' 'NSGlobalDomain KeyRepeat int 1' 'NSGlobalDomain KeyRepeat int 2' > "$PROFILE"
if MACOS_DEFAULTS_PROFILE="$PROFILE" "$SCRIPT" validate > /dev/null 2>&1; then
  fail "validate accepted a duplicate domain/key pair"
fi
for bad_int in '-' '1-2' '--3' '3-'; do
  printf '%s\n' "NSGlobalDomain KeyRepeat int $bad_int" > "$PROFILE"
  if MACOS_DEFAULTS_PROFILE="$PROFILE" "$SCRIPT" validate > /dev/null 2>&1; then
    fail "validate accepted a non-integer int: $bad_int"
  fi
done

# 3. The same key in two domains is a distinct entry, not a duplicate.
printf '%s\n' 'com.example.a Shared int 1' 'com.example.b Shared int 2' > "$PROFILE"
MACOS_DEFAULTS_PROFILE="$PROFILE" "$SCRIPT" validate > /dev/null 2>&1 ||
  fail "validate rejected the same key in two domains"

# 4. Dry-run must not create the plist; status must report drift on an empty domain.
cat > "$PROFILE" << CONF
$PLIST        KeyRepeat                 int   1
$PLIST        ApplePressAndHoldEnabled  bool  false
$OTHER_PLIST  InitialKeyRepeat          int   10
CONF
export MACOS_DEFAULTS_PROFILE="$PROFILE"
"$SCRIPT" --dry-run apply > "$TEST_ROOT/dry.out"
[ ! -e "$PLIST.plist" ] || fail "dry-run apply wrote the plist"
grep -q "defaults write $PLIST KeyRepeat -int 1" "$TEST_ROOT/dry.out" ||
  fail "dry-run did not print the defaults write command"
if "$SCRIPT" status > /dev/null 2>&1; then
  fail "status reported ok before anything was applied"
fi

# 5. Apply, then status must be clean and values must round-trip through defaults(1).
"$SCRIPT" apply > /dev/null
"$SCRIPT" status > "$TEST_ROOT/status.out" || fail "status reported drift after apply"
[ "$(defaults read "$PLIST" KeyRepeat)" = "1" ] || fail "int was not written"
[ "$(defaults read-type "$PLIST" KeyRepeat)" = "Type is integer" ] || fail "int was not written as integer"
[ "$(defaults read "$PLIST" ApplePressAndHoldEnabled)" = "0" ] || fail "bool false was not written as 0"
[ "$(defaults read "$OTHER_PLIST" InitialKeyRepeat)" = "10" ] || fail "second domain was not written"

# 6. External drift must be detected, and export-defaults must capture it.
defaults write "$PLIST" KeyRepeat -int 2
if "$SCRIPT" status > /dev/null 2>&1; then
  fail "status missed drift after an external defaults write"
fi
"$SCRIPT" export-defaults "$TEST_ROOT/exported.conf" > /dev/null
grep -q "^$PLIST  *KeyRepeat  *int  *2$" "$TEST_ROOT/exported.conf" ||
  fail "export-defaults did not capture the live value"
grep -q "^$PLIST  *ApplePressAndHoldEnabled  *bool  *false$" "$TEST_ROOT/exported.conf" ||
  fail "export-defaults did not render bool as true/false"

echo "[ok] macos-defaults.sh validate/status/apply/export behave in isolation"
