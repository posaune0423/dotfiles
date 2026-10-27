#!/bin/sh
# Enforce the Brewfile ownership contract: CLI tools belong to mise, so a
# `brew` formula must not share a name with a mise tool, and no entry may be
# declared twice.
set -eu

REPO_ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
BREWFILE="${BREWFILE:-$REPO_ROOT/.config/homebrew/Brewfile}"
MISE_CONFIG="${MISE_CONFIG:-$REPO_ROOT/.config/mise/config.toml}"
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-brewfile.XXXXXX")"
trap 'rm -rf "$WORK_DIR"' EXIT HUP INT TERM

# `brew "tap/name/formula"` -> formula
sed -nE 's/^brew "([^"]+)".*/\1/p' "$BREWFILE" | sed 's#.*/##' | sort -u > "$WORK_DIR/brew"

# `"aqua:owner/tool" = ...`, `"npm:@scope/tool" = ...`, `tool = ...` -> tool
awk '/^\[/ { in_tools = ($0 == "[tools]"); next } in_tools' "$MISE_CONFIG" |
  sed -nE 's/^"?([^"= ]+)"? *=.*/\1/p' |
  sed -E -e 's/^[a-z]+://' -e 's#.*/##' | sort -u > "$WORK_DIR/mise"

FAIL=0

sed -nE 's/^(tap|brew|cask|mas) "([^"]+)".*/\1 \2/p' "$BREWFILE" | sort | uniq -d > "$WORK_DIR/duplicates"
if [ -s "$WORK_DIR/duplicates" ]; then
  echo "[fail] declared more than once in Brewfile:" >&2
  sed 's/^/  /' "$WORK_DIR/duplicates" >&2
  FAIL=1
fi

comm -12 "$WORK_DIR/brew" "$WORK_DIR/mise" > "$WORK_DIR/overlap"
if [ -s "$WORK_DIR/overlap" ]; then
  echo "[fail] managed by both Homebrew and mise (keep it in mise only):" >&2
  sed 's/^/  /' "$WORK_DIR/overlap" >&2
  FAIL=1
fi

if [ "$FAIL" -ne 0 ]; then
  exit 1
fi

echo "[ok] Brewfile has no duplicates and no formula shared with mise"
