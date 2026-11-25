#!/bin/sh
# Hold the formulae listed in Brewfile.lock at their recorded versions.
# Homebrew has no lockfile and serves only the current bottle, so the lock is
# `brew pin` plus the version recorded in the repository: `check` reports
# drift, `pin` holds installs that match, and `bump` moves one formula to the
# current Homebrew version and records it.
set -eu

REPO_ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
LOCKFILE="${BREW_LOCKFILE:-$REPO_ROOT/.config/homebrew/Brewfile.lock}"

usage() {
  cat >&2 << 'EOF'
usage: brew-lock.sh <command>
  check            fail unless every locked formula is installed at its locked version and pinned
  pin              `brew pin` every locked formula installed at its locked version
  bump <formula>   upgrade one locked formula, record the new version, and pin it
EOF
  exit 2
}

if [ ! -r "$LOCKFILE" ]; then
  echo "[fail] cannot read $LOCKFILE" >&2
  exit 1
fi

# `formula version` lines, without comments or blank lines.
entries() {
  sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$LOCKFILE"
}

# brew reads stdin, which would swallow the entry list feeding the loops below.
installed_version() {
  brew list --versions "$1" < /dev/null 2> /dev/null | awk '{ print $NF }'
}

is_pinned() {
  brew list --pinned < /dev/null | grep -qx "$1"
}

cmd_check() {
  _fail=0
  while read -r _name _locked; do
    [ -n "$_name" ] || continue
    _installed="$(installed_version "$_name")"
    if [ -z "$_installed" ]; then
      echo "[fail] $_name: not installed (locked $_locked)" >&2
      _fail=1
    elif [ "$_installed" != "$_locked" ]; then
      echo "[fail] $_name: installed $_installed, locked $_locked (run: just brew-lock bump $_name)" >&2
      _fail=1
    elif ! is_pinned "$_name"; then
      echo "[fail] $_name $_locked: not pinned (run: just brew-lock pin)" >&2
      _fail=1
    else
      echo "[ok] $_name $_locked"
    fi
  done << EOF
$(entries)
EOF
  return "$_fail"
}

cmd_pin() {
  _fail=0
  while read -r _name _locked; do
    [ -n "$_name" ] || continue
    _installed="$(installed_version "$_name")"
    if [ "$_installed" = "$_locked" ]; then
      brew pin "$_name" < /dev/null
      echo "[ok] $_name pinned at $_locked"
    else
      echo "[fail] $_name: installed ${_installed:-nothing}, locked $_locked; not pinned" >&2
      _fail=1
    fi
  done << EOF
$(entries)
EOF
  return "$_fail"
}

cmd_bump() {
  _name="$1"
  if ! entries | grep -q "^$_name "; then
    echo "[fail] $_name is not in $LOCKFILE" >&2
    exit 1
  fi
  if [ -n "$(installed_version "$_name")" ]; then
    brew unpin "$_name"
    brew upgrade "$_name"
  else
    brew install --formula "$_name"
  fi
  _new="$(installed_version "$_name")"
  awk -v name="$_name" -v version="$_new" \
    '$1 == name { print name, version; next } { print }' "$LOCKFILE" > "$LOCKFILE.tmp"
  mv "$LOCKFILE.tmp" "$LOCKFILE"
  brew pin "$_name"
  echo "[ok] $_name locked at $_new"
}

case "${1:-}" in
  check) cmd_check ;;
  pin) cmd_pin ;;
  bump)
    [ $# -eq 2 ] || usage
    cmd_bump "$2"
    ;;
  *) usage ;;
esac
