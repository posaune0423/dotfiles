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
# is stale whenever the settings file changed while it was running (here: the
# coding mode registered after it started is missing).
FAKE_APP="$TEST_ROOT/fake-app.sh"
cat > "$FAKE_APP" << 'EOF'
#!/bin/sh
echo "$1" >> "$FAKE_APP_LOG"
case "$1" in
  running) [ "$(cat "$FAKE_APP_STATE")" = running ] ;;
  quit)
    if [ -f "$FAKE_APP_SETTINGS" ]; then
      jq '.modeKeys = ((.modeKeys // []) - ["coding"])' "$FAKE_APP_SETTINGS" > "$FAKE_APP_SETTINGS.tmp"
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

# Other settings changed in the app, such as favorite models, are kept too.
jq '.favoriteModelIDs = ["from-app"]' "$OUT" > "$OUT.tmp" && mv "$OUT.tmp" "$OUT"
expect "build refuses to drop other settings changed in the app" "$(status_of settings build)" "1"
expect "the refusal names the changed setting" \
  "$(settings build 2>&1 | grep -c 'setting: favoriteModelIDs')" "1"
settings build --force > /dev/null
expect "build --force drops the changed setting" \
  "$(jq -c '.favoriteModelIDs // "none"' "$OUT")" '"none"'

# The last build is remembered, so a change made only in the sources is not
# mistaken for an app-side change.
cp "$CONFIG/settings.json" "$TEST_ROOT/settings.public.json"
jq '.favoriteModelIDs = ["from-source"]' "$CONFIG/settings.json" > "$CONFIG/settings.json.tmp"
mv "$CONFIG/settings.json.tmp" "$CONFIG/settings.json"
expect "build applies a setting changed only in the sources" "$(status_of settings build)" "0"
expect "the built file has the source setting" \
  "$(jq -c '.favoriteModelIDs' "$OUT")" '["from-source"]'
jq '.vocabulary -= ["Alpha"]' "$CONFIG/settings.json" > "$CONFIG/settings.json.tmp"
mv "$CONFIG/settings.json.tmp" "$CONFIG/settings.json"
expect "build applies a word removed from the sources" "$(status_of settings build)" "0"
expect "the removed word is gone" "$(jq -c '.vocabulary | index("Alpha")' "$OUT")" "null"
cp "$TEST_ROOT/settings.public.json" "$CONFIG/settings.json"
settings build --force > /dev/null
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

# --- modes -------------------------------------------------------------------
# Superwhisper lists modes/ with URL-based Foundation APIs, which do not follow
# a symlinked folder, so the app folder keeps a real modes/ with copies of the
# repository's modes. push copies repo -> app, pull copies app -> repo.
MREPO="$TEST_ROOT/mrepo"
MAPP="$TEST_ROOT/mapp"
mkdir -p "$MREPO/modes" "$MAPP"
printf '{\n  "key" : "default",\n  "voiceModelID" : "sv-1"\n}\n' > "$MREPO/modes/default.json"
printf '{\n  "key" : "coding",\n  "voiceModelID" : "sv-1"\n}\n' > "$MREPO/modes/coding.json"
modes() {
  SUPERWHISPER_CONFIG_DIR="$MREPO" SUPERWHISPER_APP_DIR="$MAPP" \
    sh "$REPO_ROOT/scripts/superwhisper-modes.sh" "$@"
}
names() {
  find "$1" -maxdepth 1 -name '*.json' -exec basename {} \; | sort | tr '\n' ' ' | sed 's/ $//'
}

expect "modes status fails before the first push" "$(status_of modes status)" "1"
modes push > /dev/null
expect "push makes a real modes folder" \
  "$([ -d "$MAPP/modes" ] && [ ! -L "$MAPP/modes" ] && echo folder || echo other)" "folder"
expect "push copies every repository mode" "$(names "$MAPP/modes")" "coding.json default.json"
expect "modes status passes after push" "$(status_of modes status)" "0"

# A folder-level symlink from an earlier install is replaced by a real folder.
rm -rf "$MAPP/modes"
ln -s "$MREPO/modes" "$MAPP/modes"
expect "modes status rejects a symlinked folder" "$(status_of modes status)" "1"
modes push > /dev/null
expect "push replaces a symlinked folder with a real one" \
  "$([ -L "$MAPP/modes" ] && echo link || echo folder)" "folder"
expect "replacing the symlink keeps the repository modes" "$(names "$MREPO/modes")" "coding.json default.json"

# The app saves in its own JSON layout; layout alone is not a change.
jq . "$MAPP/modes/default.json" > "$MAPP/modes/default.json.tmp"
mv "$MAPP/modes/default.json.tmp" "$MAPP/modes/default.json"
expect "a layout-only rewrite is not drift" "$(status_of modes status)" "0"

# Edits made in the app: a changed model, a new mode.
jq '.voiceModelID = "local-model"' "$MAPP/modes/coding.json" > "$MAPP/modes/coding.json.tmp"
mv "$MAPP/modes/coding.json.tmp" "$MAPP/modes/coding.json"
echo '{"key":"local"}' > "$MAPP/modes/local.json"
expect "modes status reports app-side edits" "$(status_of modes status)" "1"
expect "push refuses to drop app-side edits" "$(status_of modes push)" "1"
expect "a refused push keeps the app-side edit" \
  "$(jq -r '.voiceModelID' "$MAPP/modes/coding.json")" "local-model"
modes pull > /dev/null
expect "pull brings a changed mode into the repository" \
  "$(jq -r '.voiceModelID' "$MREPO/modes/coding.json")" "local-model"
expect "pull brings a new mode into the repository" \
  "$(names "$MREPO/modes")" "coding.json default.json local.json"
expect "modes status passes after pull" "$(status_of modes status)" "0"

# A mode deleted in the app is deleted from the repository by pull.
rm "$MAPP/modes/local.json"
modes pull > /dev/null
expect "pull removes a mode deleted in the app" "$(names "$MREPO/modes")" "coding.json default.json"

# push --force replaces app-side edits with the repository modes.
echo '{"key":"stray"}' > "$MAPP/modes/stray.json"
modes push --force > /dev/null
expect "push --force mirrors the repository" "$(names "$MAPP/modes")" "coding.json default.json"

# A running app is quit before the push and started again afterwards.
reset_app running
modes push > /dev/null
expect "push restarts a running app around the copy" "$(app_calls)" "quit launch"
reset_app stopped

# The last synced modes are remembered, so edits made in the repository are
# not mistaken for edits made in the app.
jq '.voiceModelID = "repo-model"' "$MREPO/modes/default.json" > "$MREPO/modes/default.json.tmp"
mv "$MREPO/modes/default.json.tmp" "$MREPO/modes/default.json"
expect "push applies a repository edit without --force" "$(status_of modes push)" "0"
expect "the app gets the repository edit" \
  "$(jq -r '.voiceModelID' "$MAPP/modes/default.json")" "repo-model"
echo '{"key":"extra"}' > "$MREPO/modes/extra.json"
modes push > /dev/null
rm "$MREPO/modes/extra.json"
expect "push removes a mode deleted in the repository without --force" "$(status_of modes push)" "0"
expect "the deleted mode is gone from the app" "$(names "$MAPP/modes")" "coding.json default.json"

jq '.voiceModelID = "repo-2"' "$MREPO/modes/default.json" > "$MREPO/modes/default.json.tmp"
mv "$MREPO/modes/default.json.tmp" "$MREPO/modes/default.json"
modes pull > /dev/null
expect "pull keeps a repository edit the app has not seen" \
  "$(jq -r '.voiceModelID' "$MREPO/modes/default.json")" "repo-2"

jq '.voiceModelID = "app-2"' "$MAPP/modes/default.json" > "$MAPP/modes/default.json.tmp"
mv "$MAPP/modes/default.json.tmp" "$MAPP/modes/default.json"
expect "pull refuses when both sides changed a mode" "$(status_of modes pull)" "1"
expect "the refused pull keeps the repository edit" \
  "$(jq -r '.voiceModelID' "$MREPO/modes/default.json")" "repo-2"
expect "status names the side of each change" \
  "$(modes status 2>&1 | grep -c -E '(app|repo): changed: default.json')" "2"
modes push --force > /dev/null

# push --check only reports; it does not stop the app or write anything.
jq '.voiceModelID = "app-3"' "$MAPP/modes/coding.json" > "$MAPP/modes/coding.json.tmp"
mv "$MAPP/modes/coding.json.tmp" "$MAPP/modes/coding.json"
reset_app running
expect "push --check reports app-side edits" "$(status_of modes push --check)" "1"
expect "push --check does not stop the app" "$(app_calls)" ""
expect "push --check writes nothing" "$(jq -r '.voiceModelID' "$MAPP/modes/coding.json")" "app-3"
modes pull > /dev/null
expect "push --check passes once the edit is pulled" "$(status_of modes push --check)" "0"
reset_app stopped

# Only one push or pull runs at a time.
mkdir -p "$MREPO/.state/modes.lock"
expect "push waits for no one: it fails while the lock is held" "$(status_of modes push)" "1"
expect "pull fails while the lock is held" "$(status_of modes pull)" "1"
expect "a failed locked pull keeps the repository modes" "$(names "$MREPO/modes")" "coding.json default.json"
rmdir "$MREPO/.state/modes.lock"
expect "push works again after the lock is released" "$(status_of modes push)" "0"
expect "push releases its lock" "$([ -e "$MREPO/.state/modes.lock" ] && echo held || echo free)" "free"

# --- installer ---------------------------------------------------------------
DOTFILES="$TEST_ROOT/dotfiles"
TEST_HOME="$TEST_ROOT/home"
APP_DIR="$TEST_HOME/Documents/superwhisper"
mkdir -p "$DOTFILES/scripts" "$DOTFILES/.config/superwhisper/modes" "$TEST_HOME"
git init -q "$DOTFILES"
cp "$REPO_ROOT/install.sh" "$DOTFILES/install.sh"
cp "$REPO_ROOT/scripts/superwhisper-settings.sh" "$REPO_ROOT/scripts/superwhisper-modes.sh" \
  "$REPO_ROOT/scripts/superwhisper-app.sh" "$DOTFILES/scripts/"
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
expect "dry run previews copying the modes" \
  "$(printf '%s\n' "$DRY_OUT" | grep -c "superwhisper-modes.sh push")" "1"
expect "dry run leaves the app modes alone" "$(names "$APP_DIR/modes")" "old.json"

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
expect "modes stays a real folder" \
  "$([ -L "$APP_DIR/modes" ] && echo link || echo folder)" "folder"
expect "modes holds copies of the repository modes" "$(names "$APP_DIR/modes")" "default.json"
expect "settings links to the built folder" \
  "$(resolved "$APP_DIR/settings")" "$(resolved "$DOTFILES/.config/superwhisper/settings")"
expect "the app reads the built vocabulary" \
  "$(jq -c '.vocabulary' "$APP_DIR/settings/settings.json")" '["Alpha","Beta"]'
expect "previous modes are backed up" \
  "$(find "$TEST_HOME/.dotfiles-backup" -name old.json | wc -l | tr -d ' ')" "1"

# A folder-level symlink left by an earlier install is turned into a folder.
rm -rf "$APP_DIR/modes"
ln -s "$DOTFILES/.config/superwhisper/modes" "$APP_DIR/modes"
install
expect "install replaces a symlinked modes folder" \
  "$([ -L "$APP_DIR/modes" ] && echo link || echo folder)" "folder"
expect "the repository modes survive that replacement" \
  "$(names "$DOTFILES/.config/superwhisper/modes")" "default.json"

# Without --yes, modes edited in the app are not replaced.
jq '.voiceModelID = "app-edit"' "$APP_DIR/modes/default.json" > "$APP_DIR/modes/default.json.tmp"
mv "$APP_DIR/modes/default.json.tmp" "$APP_DIR/modes/default.json"
env -u SUPERWHISPER_CONFIG_DIR HOME="$TEST_HOME" NO_COLOR=1 \
  sh "$DOTFILES/install.sh" --no-update --dotfiles-dir "$DOTFILES" < /dev/null > /dev/null 2>&1 || true
expect "install without --yes keeps modes edited in the app" \
  "$(jq -r '.voiceModelID' "$APP_DIR/modes/default.json")" "app-edit"
env -u SUPERWHISPER_CONFIG_DIR HOME="$TEST_HOME" NO_COLOR=1 \
  sh "$DOTFILES/install.sh" --no-update --no-backup --dotfiles-dir "$DOTFILES" < /dev/null > /dev/null 2>&1 || true
expect "install --no-backup without --yes keeps them too" \
  "$(jq -r '.voiceModelID' "$APP_DIR/modes/default.json")" "app-edit"
install
expect "install --yes replaces them" \
  "$(jq -r '.voiceModelID // "unset"' "$APP_DIR/modes/default.json")" "unset"

exit "$FAIL"
