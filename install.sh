#!/bin/sh
#
# Safe dotfiles installer/updater.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh
#   curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh -s -- --dry-run
#
set -eu

# Best-effort pipefail (not POSIX, but harmless when supported)
if (set -o pipefail) 2>/dev/null; then
  set -o pipefail
fi

say() { printf "%s\n" "$*"; }
err() { printf "ERROR: %s\n" "$*" >&2; }
die() { err "$*"; exit 1; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

realpath_compat() {
  # Prints a canonical absolute path (resolves symlinks) if possible.
  # Falls back to the input path if no suitable tool exists.
  _p="$1"
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$_p" <<'PY'
import os, sys
print(os.path.realpath(sys.argv[1]))
PY
    return 0
  fi
  if command -v python >/dev/null 2>&1; then
    python - "$_p" <<'PY'
import os, sys
print(os.path.realpath(sys.argv[1]))
PY
    return 0
  fi
  if command -v perl >/dev/null 2>&1; then
    perl -MCwd -e 'print Cwd::realpath($ARGV[0])' "$_p" 2>/dev/null || printf "%s" "$_p"
    printf "\n"
    return 0
  fi
  printf "%s\n" "$_p"
}

timestamp() {
  # YYYYMMDD-HHMMSS
  date "+%Y%m%d-%H%M%S"
}

DRY_RUN=0
FORCE=0
NO_UPDATE=0
NO_BACKUP=0
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
REPO_URL="${REPO_URL:-https://github.com/posaune0423/dotfiles.git}"
BRANCH="${BRANCH:-main}"
BACKUP_ROOT="${BACKUP_ROOT:-$HOME/.dotfiles-backup}"

has_tty() {
  # curl | sh makes stdin non-tty; read prompts from /dev/tty instead.
  [ -r /dev/tty ] && [ -c /dev/tty ]
}

confirm() {
  # Usage: confirm "Question"  (returns 0 for yes, 1 for no)
  _q="$1"
  if [ "$FORCE" -eq 1 ]; then
    return 0
  fi
  if ! has_tty; then
    die "No TTY available for interactive prompt. Re-run with --yes (or --force)."
  fi
  printf "%s [y/N]: " "$_q" >/dev/tty
  IFS= read -r _ans </dev/tty || _ans=""
  case "$_ans" in
    y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

usage() {
  cat <<EOF
install.sh - safely apply this dotfiles repo to your home directory.

Options:
  --dry-run        Print actions without changing anything
  --yes            Answer yes to all prompts (non-interactive)
  --force          Alias of --yes
  --no-update      Do not git pull if repo already exists
  --no-backup      Do not backup existing files (NOT recommended)
  --dotfiles-dir   Install location (default: \$HOME/.dotfiles)
  --repo           Git repo URL (default: $REPO_URL)
  --branch         Git branch (default: $BRANCH)
  -h, --help       Show this help

Examples:
  curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh
  curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh -s -- --dry-run
  DOTFILES_DIR="\$HOME/src/dotfiles" curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --yes) FORCE=1 ;;
    --force) FORCE=1 ;;
    --no-update) NO_UPDATE=1 ;;
    --no-backup) NO_BACKUP=1 ;;
    --dotfiles-dir)
      shift || true
      [ $# -gt 0 ] || die "--dotfiles-dir requires a value"
      DOTFILES_DIR="$1"
      ;;
    --repo)
      shift || true
      [ $# -gt 0 ] || die "--repo requires a value"
      REPO_URL="$1"
      ;;
    --branch)
      shift || true
      [ $# -gt 0 ] || die "--branch requires a value"
      BRANCH="$1"
      ;;
    -h|--help) usage; exit 0 ;;
    *)
      die "Unknown option: $1 (use --help)"
      ;;
  esac
  shift
done

need_cmd git

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    say "[dry-run] $*"
    return 0
  fi
  # shellcheck disable=SC2086
  "$@"
}

backup_path() {
  _dest="$1"
  _ts="$2"
  _backup_dir="$BACKUP_ROOT/$_ts"

  case "$_dest" in
    "$HOME"/*) _rel="${_dest#"$HOME"/}" ;;
    *) _rel="nonhome/$_dest" ;;
  esac

  printf "%s\n" "$_backup_dir/$_rel"
}

link_item() {
  _src="$1"
  _dest="$2"
  _ts="$3"

  [ -e "$_src" ] || die "Source does not exist: $_src"

  # Already correct?
  if [ -e "$_dest" ] || [ -L "$_dest" ]; then
    _src_r="$(realpath_compat "$_src")"
    _dest_r="$(realpath_compat "$_dest")"
    if [ "$_src_r" = "$_dest_r" ]; then
      say "ok: $_dest"
      return 0
    fi
  fi

  # Ensure parent dir exists
  _parent="$(dirname "$_dest")"
  [ -d "$_parent" ] || run mkdir -p "$_parent"

  # Prompt only when we're going to change something on disk.
  if ( [ -e "$_dest" ] || [ -L "$_dest" ] ); then
    if ! confirm "Update $_dest ?"; then
      say "skip: $_dest"
      return 0
    fi
  fi

  # Backup existing
  if [ "$NO_BACKUP" -eq 0 ] && ( [ -e "$_dest" ] || [ -L "$_dest" ] ); then
    _bk="$(backup_path "$_dest" "$_ts")"
    _bk_parent="$(dirname "$_bk")"
    [ -d "$_bk_parent" ] || run mkdir -p "$_bk_parent"
    say "backup: $_dest -> $_bk"
    run mv "$_dest" "$_bk"
  elif ( [ -e "$_dest" ] || [ -L "$_dest" ] ); then
    if [ "$FORCE" -ne 1 ]; then
      die "Destination exists (use --force or keep backup enabled): $_dest"
    fi
    say "remove: $_dest"
    run rm -rf "$_dest"
  fi

  say "link: $_dest -> $_src"
  run ln -s "$_src" "$_dest"
}

say "dotfiles: $REPO_URL ($BRANCH)"
say "install:  $DOTFILES_DIR"

if [ ! -d "$DOTFILES_DIR" ]; then
  say "clone:   $REPO_URL -> $DOTFILES_DIR"
  run git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$DOTFILES_DIR"
else
  [ -d "$DOTFILES_DIR/.git" ] || die "DOTFILES_DIR exists but is not a git repo: $DOTFILES_DIR"
  if [ "$NO_UPDATE" -eq 0 ]; then
    if confirm "Pull latest changes into $DOTFILES_DIR ?"; then
      say "update:  git pull (ff-only)"
      run git -C "$DOTFILES_DIR" fetch --prune origin
      run git -C "$DOTFILES_DIR" checkout "$BRANCH"
      run git -C "$DOTFILES_DIR" pull --ff-only
    else
      say "update:  skipped (user declined)"
    fi
  else
    say "update:  skipped (--no-update)"
  fi
fi

TS="$(timestamp)"

# Ensure XDG config home exists
run mkdir -p "$HOME/.config"

# Root dotfiles
link_item "$DOTFILES_DIR/.zshenv"    "$HOME/.zshenv"    "$TS"
link_item "$DOTFILES_DIR/.zshrc"     "$HOME/.zshrc"     "$TS"
link_item "$DOTFILES_DIR/.zprofile"  "$HOME/.zprofile"  "$TS"
link_item "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig" "$TS"

# XDG configs (link individual apps, not ~/.config as a whole)
link_item "$DOTFILES_DIR/.config/zsh"       "$HOME/.config/zsh"       "$TS"
link_item "$DOTFILES_DIR/.config/nvim"      "$HOME/.config/nvim"      "$TS"
link_item "$DOTFILES_DIR/.config/wezterm"   "$HOME/.config/wezterm"   "$TS"
link_item "$DOTFILES_DIR/.config/mise"      "$HOME/.config/mise"      "$TS"
link_item "$DOTFILES_DIR/.config/karabiner" "$HOME/.config/karabiner" "$TS"
link_item "$DOTFILES_DIR/.config/ghosty"    "$HOME/.config/ghosty"    "$TS"
link_item "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml" "$TS"

say "done."
if [ "$NO_BACKUP" -eq 0 ]; then
  say "backup dir: $BACKUP_ROOT/$TS"
fi
