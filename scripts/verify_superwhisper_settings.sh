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

# Stand-in for scripts/superwhisper-app.sh, so no test touches the real app.
# Like Superwhisper, it saves its in-memory settings when it quits; that write
# is stale whenever the settings file changed while it was running.
FAKE_APP="$TEST_ROOT/fake-app.sh"
cat > "$FAKE_APP" << 'EOF'
#!/bin/sh
echo "$1" >> "$FAKE_APP_LOG"
case "$1" in
  running) [ "$(cat "$FAKE_APP_STATE")" = running ] ;;
  quit)
    if [ -f "$FAKE_APP_SETTINGS" ]; then
      jq '.modeKeys = ["stale"]' "$FAKE_APP_SETTINGS" > "$FAKE_APP_SETTINGS.tmp"
      mv "$FAKE_APP_SETTINGS.tmp" "$FAKE_APP_SETTINGS"
    fi
    echo stopped > "$FAKE_APP_STATE"
    ;;
  launch) echo running > "$FAKE_APP_STATE" ;;
  *) exit 2 ;;
esac
EOF
export SUPERWHISPER_APP_CTL="$FAKE_APP"
export FAKE_APP_LOG="$TEST_ROOT/fake-app.log"
export FAKE_APP_STATE="$TEST_ROOT/fake-app.state"
export FAKE_APP_SETTINGS="$TEST_ROOT/none"
echo stopped > "$FAKE_APP_STATE"
app_calls() {
  grep -v '^running$' "$FAKE_APP_LOG" 2> /dev/null | tr '\n' ' ' | sed 's/ $//'
}
reset_app() {
  echo "$1" > "$FAKE_APP_STATE"
  : > "$FAKE_APP_LOG"
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
expect "the built file stays readable by the app" \
  "$(find "$OUT" -perm -044 | wc -l | tr -d ' ')" "1"
expect "no temporary file is left next to the built settings" \
  "$(find "$CONFIG/settings" -name '.settings.json.*' | wc -l | tr -d ' ')" "0"

# Every tracked mode is registered in modeKeys, or the app never loads it.
# system-* modes are built in and stay out of modeKeys.
mkdir -p "$CONFIG/modes"
for key in default coding system-meeting; do
  echo "{\"key\":\"$key\"}" > "$CONFIG/modes/$key.json"
done
settings build > /dev/null
expect "tracked modes missing from modeKeys are registered in order" \
  "$(jq -c '.modeKeys' "$OUT")" '["default","coding"]'

# --- running app -------------------------------------------------------------
# A running Superwhisper writes its own state back over the built file, which
# is how a freshly registered mode disappeared. build stops it first and
# starts it again afterwards.
export FAKE_APP_SETTINGS="$OUT"
reset_app stopped
settings build > /dev/null
expect "build leaves a stopped app alone" "$(app_calls)" ""

reset_app running
settings build > /dev/null
expect "build restarts a running app around the write" "$(app_calls)" "quit launch"
expect "the app's save on quit does not survive the build" \
  "$(jq -c '.modeKeys' "$OUT")" '["default","coding"]'
expect "the app is running again" "$(cat "$FAKE_APP_STATE")" "running"

jq '.vocabulary += ["FromApp"]' "$OUT" > "$OUT.tmp" && mv "$OUT.tmp" "$OUT"
reset_app running
expect "build still refuses app-side edits" "$(status_of settings build)" "1"
expect "a refused build starts the app again" "$(app_calls)" "quit launch"
settings build --force > /dev/null
export FAKE_APP_SETTINGS="$TEST_ROOT/none"
reset_app stopped

# --- installer ---------------------------------------------------------------
DOTFILES="$TEST_ROOT/dotfiles"
TEST_HOME="$TEST_ROOT/home"
APP_DIR="$TEST_HOME/Documents/superwhisper"
mkdir -p "$DOTFILES/scripts" "$DOTFILES/.config/superwhisper/modes" "$TEST_HOME"
git init -q "$DOTFILES"
cp "$REPO_ROOT/install.sh" "$DOTFILES/install.sh"
cp "$REPO_ROOT/scripts/superwhisper-settings.sh" "$REPO_ROOT/scripts/superwhisper-app.sh" "$DOTFILES/scripts/"
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

# The settings folder is generated by the build, which a dry run skips. The
# preview must still report that the app's settings folder gets replaced.
DRY_OUT="$(env -u SUPERWHISPER_CONFIG_DIR HOME="$TEST_HOME" NO_COLOR=1 \
  sh "$DOTFILES/install.sh" --dry-run --yes --no-update --dotfiles-dir "$DOTFILES" 2>&1)"
expect "dry run previews the settings link before the first build" \
  "$(printf '%s\n' "$DRY_OUT" | grep -c "ln -s .*/superwhisper/settings .*/superwhisper/settings$")" "1"
expect "dry run previews the settings backup" \
  "$(printf '%s\n' "$DRY_OUT" | grep -c "mv .*/Documents/superwhisper/settings ")" "1"
expect "dry run builds nothing" \
  "$([ -e "$DOTFILES/.config/superwhisper/settings" ] && echo present || echo absent)" "absent"
expect "dry run leaves the app settings folder alone" \
  "$([ -L "$APP_DIR/settings" ] && echo link || echo folder)" "folder"
expect "dry run does not stop the app" "$(app_calls)" ""

# A failed first build must not replace the app's working settings.
cp "$DOTFILES/.config/superwhisper/settings.json" "$TEST_ROOT/settings.good.json"
echo '{ broken' > "$DOTFILES/.config/superwhisper/settings.json"
mkdir -p "$DOTFILES/.config/superwhisper/settings"
echo '{"vocabulary":["Existing"]}' > "$APP_DIR/settings/settings.json"
install
expect "a failed build leaves the app settings folder in place" \
  "$([ -L "$APP_DIR/settings" ] && echo link || echo folder)" "folder"
expect "a failed build keeps the app's settings readable" \
  "$(jq -c '.vocabulary' "$APP_DIR/settings/settings.json")" '["Existing"]'
cp "$TEST_ROOT/settings.good.json" "$DOTFILES/.config/superwhisper/settings.json"
rmdir "$DOTFILES/.config/superwhisper/settings"
rm -rf "$APP_DIR/modes" "$TEST_HOME/.dotfiles-backup"
mkdir -p "$APP_DIR/modes"
echo '{"key":"old"}' > "$APP_DIR/modes/old.json"

export FAKE_APP_SETTINGS="$APP_DIR/settings/settings.json"
reset_app running
install
expect "install stops the running app once and starts it again" "$(app_calls)" "quit launch"
expect "modes links to the repository" \
  "$(resolved "$APP_DIR/modes")" "$(resolved "$DOTFILES/.config/superwhisper/modes")"
expect "settings links to the built folder" \
  "$(resolved "$APP_DIR/settings")" "$(resolved "$DOTFILES/.config/superwhisper/settings")"
expect "the app reads the built vocabulary" \
  "$(jq -c '.vocabulary' "$APP_DIR/settings/settings.json")" '["Alpha","Beta"]'
expect "previous modes are backed up" \
  "$(find "$TEST_HOME/.dotfiles-backup" -name old.json | wc -l | tr -d ' ')" "1"

exit "$FAIL"
