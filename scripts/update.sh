#!/bin/sh
# Update every package manager this repository owns in one pass:
# Homebrew (formulae + casks), Mac App Store, and mise.
# A failing step does not stop later ones; the exit status reports any failure.
set -u

REPO_ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
BREWFILE="$REPO_ROOT/.config/homebrew/Brewfile"
FAILED=""

step() {
  _name="$1"
  shift
  printf '\n==> %s\n' "$_name"
  if ! "$@"; then
    FAILED="$FAILED
  $_name"
  fi
}

step "brew update" brew update
# --greedy also upgrades casks that update themselves (browsers, chat apps),
# whose own updaters can lag for weeks. --no-quit keeps running apps open so
# an update never drops unsaved work; the new build loads on relaunch.
step "brew upgrade" brew upgrade --greedy --no-quit
step "mas upgrade" mas upgrade
# Keeps each range in mise config ("latest" moves, exact pins stay).
step "mise upgrade" mise upgrade
step "brew cleanup" brew cleanup

# `type "name"` lines, without trailing options or comments.
entries() {
  sed -nE 's/^(tap|brew|cask|mas) ("[^"]+").*/\1 \2/p' | sort -u
}

# Drift reports are read-only. Never call `brew bundle cleanup` here: it
# uninstalls after a prompt and resets Homebrew's trust store to the Brewfile.
printf '\n==> Brewfile entries not installed through Homebrew/mas\n'
brew bundle check --file "$BREWFILE" --verbose --no-upgrade || true
printf '\n==> Installed through Homebrew/mas but missing from Brewfile\n'
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-update.XXXXXX")"
trap 'rm -rf "$WORK_DIR"' EXIT HUP INT TERM
entries < "$BREWFILE" > "$WORK_DIR/declared"
# Compare leaves only: Homebrew also flags many dependencies as installed on
# request, so `brew list --installed-on-request` would bury real drift.
{
  brew tap | sed 's/.*/tap "&"/'
  brew leaves --installed-on-request | sed 's/.*/brew "&"/'
  brew list --cask --full-name | sed 's/.*/cask "&"/'
} | entries > "$WORK_DIR/installed"
comm -13 "$WORK_DIR/declared" "$WORK_DIR/installed"
# App Store names are display labels, so compare apps by ID.
DECLARED_MAS="$(sed -nE 's/^mas "[^"]+", id: ([0-9]+).*/\1/p' "$BREWFILE" | tr '\n' ' ')"
mas list | awk -v ids="$DECLARED_MAS" '
  BEGIN { n = split(ids, list, " "); for (i = 1; i <= n; i++) declared[list[i]] }
  !($1 in declared) { $1 = $1; print "mas " $0 }'

printf '\n==> macOS updates (not installed by this script)\n'
softwareupdate --list 2>&1 || true

printf '\nRelaunch updated apps: an app keeps running its old build until it quits.\n'

if [ -n "$FAILED" ]; then
  printf '\n[fail] these steps failed:%s\n' "$FAILED" >&2
  exit 1
fi
