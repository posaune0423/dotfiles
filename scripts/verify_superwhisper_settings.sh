#!/bin/sh
# Superwhisper settings are built from a tracked public file plus an untracked
# private one, and the installer links the app's modes/ and settings/ folders
# into the repository. Both run here against a temporary config dir and HOME.
set -eu

REPO_ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-superwhisper.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT HUP INT TERM

if ! command -v jq > /dev/null 2>&1; then
  echo "[fail] jq not found" >&2
  exit 1
fi

FAIL=0
expect() {
  if [ "$2" != "$3" ]; then
    echo "[fail] $1: expected $3, got $2" >&2
    FAIL=1
  else
    echo "[ok] $1"
  fi
}

# --- merge -------------------------------------------------------------------
CONFIG="$TEST_ROOT/config"
OUT="$CONFIG/settings/settings.json"
mkdir -p "$CONFIG"
cat > "$CONFIG/settings.json" << 'EOF'
{
  "modeKeys": ["default"],
  "vocabulary": ["Alpha", "Beta"],
  "replacements": [
    { "id": "1", "original": "あるふぁ", "with": "Alpha" },
    { "id": "2", "original": "べーた", "with": "Beta" }
  ]
}
EOF

settings() {
  SUPERWHISPER_CONFIG_DIR="$CONFIG" sh "$REPO_ROOT/scripts/superwhisper-settings.sh" "$@"
}
status_of() {
  if "$@" > /dev/null 2>&1; then echo 0; else echo 1; fi
}

expect "status fails before the first build" "$(status_of settings status)" "1"

settings build > /dev/null
expect "public only: vocabulary" "$(jq -c '.vocabulary' "$OUT")" '["Alpha","Beta"]'
expect "public only: other keys kept" "$(jq -c '.modeKeys' "$OUT")" '["default"]'

cat > "$CONFIG/settings.local.json" << 'EOF'
{
  "vocabulary": ["Beta", "Secret"],
  "replacements": [
    { "id": "3", "original": "べーた", "with": "BETA" },
    { "id": "4", "original": "しーくれっと", "with": "Secret" }
  ]
}
EOF

expect "status reports stale output" "$(status_of settings status)" "1"
settings build > /dev/null
expect "merged vocabulary is deduplicated in order" \
  "$(jq -c '.vocabulary' "$OUT")" '["Alpha","Beta","Secret"]'
expect "private replacement wins on the same original" \
  "$(jq -c '[.replacements[] | "\(.original)=\(.with)"]' "$OUT")" \
  '["あるふぁ=Alpha","べーた=BETA","しーくれっと=Secret"]'
expect "status passes after build" "$(status_of settings status)" "0"

# An entry added through the app exists only in the built file.
jq '.vocabulary += ["FromApp"]' "$OUT" > "$OUT.tmp" && mv "$OUT.tmp" "$OUT"
expect "status reports app-side edits" "$(status_of settings status)" "1"
expect "build refuses to drop app-side edits" "$(status_of settings build)" "1"
expect "refused build keeps the app-side edit" \
  "$(jq -c '.vocabulary | index("FromApp") != null' "$OUT")" "true"
settings build --force > /dev/null
expect "build --force rebuilds from the sources" \
  "$(jq -c '.vocabulary' "$OUT")" '["Alpha","Beta","Secret"]'

# --- installer ---------------------------------------------------------------
DOTFILES="$TEST_ROOT/dotfiles"
TEST_HOME="$TEST_ROOT/home"
APP_DIR="$TEST_HOME/Documents/superwhisper"
mkdir -p "$DOTFILES/scripts" "$DOTFILES/.config/superwhisper/modes" "$TEST_HOME"
git init -q "$DOTFILES"
cp "$REPO_ROOT/install.sh" "$DOTFILES/install.sh"
cp "$REPO_ROOT/scripts/superwhisper-settings.sh" "$DOTFILES/scripts/"
cp "$CONFIG/settings.json" "$DOTFILES/.config/superwhisper/settings.json"
echo '{"key":"default"}' > "$DOTFILES/.config/superwhisper/modes/default.json"

install() {
  env -u SUPERWHISPER_CONFIG_DIR HOME="$TEST_HOME" NO_COLOR=1 \
    sh "$DOTFILES/install.sh" --yes --no-update --dotfiles-dir "$DOTFILES" > /dev/null 2>&1
}
resolved() {
  (CDPATH='' cd -- "$1" 2> /dev/null && pwd -P) || echo "unresolved"
}

install
expect "app folder is not created when Superwhisper is absent" \
  "$([ -e "$APP_DIR" ] && echo present || echo absent)" "absent"

mkdir -p "$APP_DIR/modes" "$APP_DIR/settings"
echo '{"key":"old"}' > "$APP_DIR/modes/old.json"
install
expect "modes links to the repository" \
  "$(resolved "$APP_DIR/modes")" "$(resolved "$DOTFILES/.config/superwhisper/modes")"
expect "settings links to the built folder" \
  "$(resolved "$APP_DIR/settings")" "$(resolved "$DOTFILES/.config/superwhisper/settings")"
expect "the app reads the built vocabulary" \
  "$(jq -c '.vocabulary' "$APP_DIR/settings/settings.json")" '["Alpha","Beta"]'
expect "previous modes are backed up" \
  "$(find "$TEST_HOME/.dotfiles-backup" -name old.json | wc -l | tr -d ' ')" "1"

exit "$FAIL"
