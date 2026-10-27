#!/bin/sh
# Enforce the Brewfile ownership contract: CLI tools belong to mise, so a
# `brew` formula must not share a name with a mise tool or appear in
# HOMEBREW_FORBIDDEN_FORMULAE (.zshenv), and no entry may be declared twice.
set -eu

REPO_ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
BREWFILE="${BREWFILE:-$REPO_ROOT/.config/homebrew/Brewfile}"
MISE_CONFIG="${MISE_CONFIG:-$REPO_ROOT/.config/mise/config.toml}"
ZSHENV="${ZSHENV:-$REPO_ROOT/.zshenv}"
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-brewfile.XXXXXX")"
trap 'rm -rf "$WORK_DIR"' EXIT HUP INT TERM

# A missing input would otherwise parse as empty and pass silently.
for f in "$BREWFILE" "$MISE_CONFIG" "$ZSHENV"; do
  if [ ! -r "$f" ]; then
    echo "[fail] cannot read $f" >&2
    exit 1
  fi
done

FAIL=0

# Every check below (and update.sh's drift report) parses `type "name"` at
# column 0, and App Store apps by `id:`. Brewfile is Ruby, so reject any other
# spelling (single quotes, indentation, missing id) instead of skipping it.
grep -vnE '^[[:space:]]*(#|$)|^(tap|brew|cask) "[^"]+"|^mas "[^"]+", id: [0-9]+' "$BREWFILE" > "$WORK_DIR/unsupported" || true
if [ -s "$WORK_DIR/unsupported" ]; then
  echo '[fail] write declarations as: type "name" (double quotes, no indentation; mas needs id:):' >&2
  sed 's/^/  /' "$WORK_DIR/unsupported" >&2
  FAIL=1
fi

# `brew "tap/name/formula@1"` -> formula@1
sed -nE 's/^brew "([^"]+)".*/\1/p' "$BREWFILE" | sed 's#.*/##' | sort -u > "$WORK_DIR/brew"
sed 's/@.*//' "$WORK_DIR/brew" | sort -u > "$WORK_DIR/brew-unversioned"

# Homebrew formula -> mise tool, where the same tool goes by a different name.
cat > "$WORK_DIR/aliases" << 'EOF'
awscli aws
docker docker-cli
gh github-cli
git-delta delta
EOF
awk 'NR == FNR { alias[$1] = $2; next } { print ($1 in alias) ? alias[$1] : $1 }' \
  "$WORK_DIR/aliases" "$WORK_DIR/brew-unversioned" | sort -u > "$WORK_DIR/brew-as-mise"

# `"aqua:owner/tool" = ...`, `"npm:@scope/tool" = ...`, `tool = ...` -> tool
awk '/^\[/ { in_tools = ($0 == "[tools]"); next } in_tools' "$MISE_CONFIG" |
  sed -nE 's/^"?([^"= ]+)"? *=.*/\1/p' |
  sed -E -e 's/^[a-z]+://' -e 's#.*/##' | sort -u > "$WORK_DIR/mise"

sed -nE 's/^(tap|brew|cask|mas) "([^"]+)".*/\1 \2/p' "$BREWFILE" | sort | uniq -d > "$WORK_DIR/duplicates"
if [ -s "$WORK_DIR/duplicates" ]; then
  echo "[fail] declared more than once in Brewfile:" >&2
  sed 's/^/  /' "$WORK_DIR/duplicates" >&2
  FAIL=1
fi

comm -12 "$WORK_DIR/brew-as-mise" "$WORK_DIR/mise" > "$WORK_DIR/overlap"
if [ -s "$WORK_DIR/overlap" ]; then
  echo "[fail] managed by both Homebrew and mise (keep it in mise only):" >&2
  sed 's/^/  /' "$WORK_DIR/overlap" >&2
  FAIL=1
fi

# Forbidden names are unversioned, so `openjdk@17` must match `openjdk`.
sed -nE 's/^export HOMEBREW_FORBIDDEN_FORMULAE="([^"]*)".*/\1/p' "$ZSHENV" |
  tr ' ' '\n' | sed '/^$/d' | sort -u > "$WORK_DIR/forbidden"
if [ ! -s "$WORK_DIR/forbidden" ]; then
  echo "[fail] HOMEBREW_FORBIDDEN_FORMULAE not found in $ZSHENV" >&2
  FAIL=1
fi
comm -12 "$WORK_DIR/brew-unversioned" "$WORK_DIR/forbidden" > "$WORK_DIR/forbidden-hits"
if [ -s "$WORK_DIR/forbidden-hits" ]; then
  echo "[fail] listed in HOMEBREW_FORBIDDEN_FORMULAE (install through mise instead):" >&2
  sed 's/^/  /' "$WORK_DIR/forbidden-hits" >&2
  FAIL=1
fi

if [ "$FAIL" -ne 0 ]; then
  exit 1
fi

echo "[ok] Brewfile has no duplicates and no formula owned by mise"
