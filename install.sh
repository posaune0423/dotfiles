#!/bin/sh
#
# Safe dotfiles installer/updater.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh
#   curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh -s -- --dry-run
#
set -eu

# Best-effort pipefail (not POSIX, but harmless when supported)
if (set -o pipefail) 2> /dev/null; then
  set -o pipefail
fi

# =============================================================================
# Color & Formatting
# =============================================================================
setup_colors() {
  if [ -t 1 ] && [ -n "${TERM:-}" ] && [ "$TERM" != "dumb" ]; then
    # Use printf to create actual escape character (POSIX-compliant)
    ESC=$(printf '\033')
    BOLD="${ESC}[1m"
    DIM="${ESC}[2m"
    RESET="${ESC}[0m"
    RED="${ESC}[31m"
    GREEN="${ESC}[32m"
    YELLOW="${ESC}[33m"
    BLUE="${ESC}[34m"
    MAGENTA="${ESC}[35m"
    CYAN="${ESC}[36m"
    WHITE="${ESC}[37m"
    BG_GREEN="${ESC}[42m"
    BG_BLUE="${ESC}[44m"
  else
    BOLD="" DIM="" RESET=""
    RED="" GREEN="" YELLOW="" BLUE="" MAGENTA="" CYAN="" WHITE=""
    BG_GREEN="" BG_BLUE=""
  fi
}
setup_colors

# =============================================================================
# Icons (Unicode)
# =============================================================================
ICON_CHECK="✓"
ICON_CROSS="✗"
ICON_ARROW="→"
ICON_LINK="🔗"
ICON_BACKUP="📦"
ICON_SKIP="⏭"
ICON_INFO="ℹ"
ICON_WARN="⚠"
ICON_ROCKET="🚀"
ICON_FOLDER="📁"
ICON_GIT="🔄"
ICON_QUESTION="❓"

# =============================================================================
# Output Helpers
# =============================================================================
print_header() {
  printf "\n"
  printf "${BOLD}${BLUE}%s${RESET}\n" "═══════════════════════════════════════════════════════════════════"
  printf "${BOLD}${BLUE}  %s${RESET}\n" "$1"
  printf "${BOLD}${BLUE}%s${RESET}\n" "═══════════════════════════════════════════════════════════════════"
}

print_section() {
  printf "\n${BOLD}${CYAN}%s %s${RESET}\n" "$ICON_ARROW" "$1"
  printf "${DIM}%s${RESET}\n" "───────────────────────────────────────────────────────────────────"
}

say() { printf "${WHITE}%s${RESET}\n" "$*"; }

info() { printf "${CYAN}${ICON_INFO}${RESET}  %s\n" "$*"; }

success() { printf "${GREEN}${ICON_CHECK}${RESET}  ${GREEN}%s${RESET}\n" "$*"; }

warn() { printf "${YELLOW}${ICON_WARN}${RESET}  ${YELLOW}%s${RESET}\n" "$*"; }

err() { printf "${RED}${ICON_CROSS}${RESET}  ${RED}ERROR: %s${RESET}\n" "$*" >&2; }

die() {
  err "$*"
  exit 1
}

skip() { printf "${DIM}${ICON_SKIP}${RESET}  ${DIM}%s${RESET}\n" "$*"; }

link_msg() { printf "${GREEN}${ICON_LINK}${RESET}  ${WHITE}%s${RESET} ${ICON_ARROW} ${CYAN}%s${RESET}\n" "$1" "$2"; }

backup_msg() { printf "${YELLOW}${ICON_BACKUP}${RESET}  ${DIM}backup:${RESET} %s\n" "$1"; }

ok_msg() { printf "${GREEN}${ICON_CHECK}${RESET}  ${DIM}unchanged:${RESET} %s\n" "$1"; }

dry_run_msg() { printf "${MAGENTA}[dry-run]${RESET} %s\n" "$*"; }

# Progress indicator
TOTAL_ITEMS=0
CURRENT_ITEM=0

set_total_items() {
  TOTAL_ITEMS=$1
  CURRENT_ITEM=0
}

progress() {
  CURRENT_ITEM=$((CURRENT_ITEM + 1))
  _name="$1"
  printf "${DIM}[%d/%d]${RESET} ${BOLD}%s${RESET}\n" "$CURRENT_ITEM" "$TOTAL_ITEMS" "$_name"
}

# =============================================================================
# Utilities
# =============================================================================
need_cmd() {
  command -v "$1" > /dev/null 2>&1 || die "Required command not found: $1"
}

realpath_compat() {
  _p="$1"
  if command -v python3 > /dev/null 2>&1; then
    python3 - "$_p" << 'PY'
import os, sys
print(os.path.realpath(sys.argv[1]))
PY
    return 0
  fi
  if command -v python > /dev/null 2>&1; then
    python - "$_p" << 'PY'
import os, sys
print(os.path.realpath(sys.argv[1]))
PY
    return 0
  fi
  if command -v perl > /dev/null 2>&1; then
    perl -MCwd -e 'print Cwd::realpath($ARGV[0])' "$_p" 2> /dev/null || printf "%s" "$_p"
    printf "\n"
    return 0
  fi
  printf "%s\n" "$_p"
}

timestamp() {
  date "+%Y%m%d-%H%M%S"
}

short_path() {
  # Replace $HOME with ~ for display
  _path="$1"
  case "$_path" in
    "$HOME"/*) printf "~/%s" "${_path#"$HOME"/}" ;;
    "$HOME") printf "~" ;;
    *) printf "%s" "$_path" ;;
  esac
}

# =============================================================================
# Configuration
# =============================================================================
DRY_RUN=0
FORCE=0
NO_UPDATE=0
NO_BACKUP=0
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
REPO_URL="${REPO_URL:-https://github.com/posaune0423/dotfiles.git}"
BRANCH="${BRANCH:-main}"
BACKUP_ROOT="${BACKUP_ROOT:-$HOME/.dotfiles-backup}"

has_tty() {
  # Check if /dev/tty is available for interactive prompts
  # Use subshell to suppress any error messages
  ([ -r /dev/tty ] && [ -w /dev/tty ] && [ -c /dev/tty ]) 2> /dev/null
}

confirm() {
  _q="$1"
  if [ "$FORCE" -eq 1 ]; then
    return 0
  fi
  if ! has_tty; then
    die "No TTY available for interactive prompt. Re-run with --yes (or --force)."
  fi
  printf "${YELLOW}${ICON_QUESTION}${RESET}  ${BOLD}%s${RESET} ${DIM}[y/N]:${RESET} " "$_q" > /dev/tty
  IFS= read -r _ans < /dev/tty || _ans=""
  case "$_ans" in
    y | Y | yes | YES) return 0 ;;
    *) return 1 ;;
  esac
}

confirm_update() {
  _file="$1"
  _short="$(short_path "$_file")"
  if [ "$FORCE" -eq 1 ]; then
    return 0
  fi
  if ! has_tty; then
    # No TTY, skip by default in non-forced mode
    return 1
  fi

  # All TTY output in a subshell to catch redirection errors
  {
    printf "\n"
    printf "${YELLOW}${ICON_WARN}${RESET}  ${BOLD}File already exists:${RESET} ${CYAN}%s${RESET}\n" "$_short"

    # Show what it currently points to if it's a symlink
    if [ -L "$_file" ]; then
      _target="$(readlink "$_file" 2> /dev/null || echo "unknown")"
      printf "   ${DIM}Current link target:${RESET} %s\n" "$(short_path "$_target")"
    elif [ -f "$_file" ]; then
      printf "   ${DIM}Type: regular file${RESET}\n"
    elif [ -d "$_file" ]; then
      printf "   ${DIM}Type: directory${RESET}\n"
    fi

    printf "${YELLOW}${ICON_QUESTION}${RESET}  ${BOLD}Replace with new symlink?${RESET} ${DIM}[y/N]:${RESET} "
  } > /dev/tty 2> /dev/null || return 1

  IFS= read -r _ans < /dev/tty 2> /dev/null || _ans=""
  case "$_ans" in
    y | Y | yes | YES) return 0 ;;
    *) return 1 ;;
  esac
}

usage() {
  printf "${BOLD}${BLUE}%s${RESET}\n" "╔═══════════════════════════════════════════════════════════════════╗"
  printf "${BOLD}${BLUE}%s${RESET}\n" "║                     Dotfiles Installer                            ║"
  printf "${BOLD}${BLUE}%s${RESET}\n" "╚═══════════════════════════════════════════════════════════════════╝"
  printf "\n"
  cat << EOF
${BOLD}USAGE:${RESET}
    ${CYAN}curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh${RESET}
    ${CYAN}curl -fsSL ... | sh -s -- --dry-run${RESET}

${BOLD}OPTIONS:${RESET}
    ${GREEN}--dry-run${RESET}        Print actions without changing anything
    ${GREEN}--yes${RESET}            Answer yes to all prompts (non-interactive)
    ${GREEN}--force${RESET}          Alias of --yes
    ${GREEN}--no-update${RESET}      Do not git pull if repo already exists
    ${GREEN}--no-backup${RESET}      Do not backup existing files (${YELLOW}NOT recommended${RESET})
    ${GREEN}--dotfiles-dir${RESET}   Install location (default: ${DIM}\$HOME/.dotfiles${RESET})
    ${GREEN}--repo${RESET}           Git repo URL
    ${GREEN}--branch${RESET}         Git branch (default: ${DIM}main${RESET})
    ${GREEN}-h, --help${RESET}       Show this help

${BOLD}EXAMPLES:${RESET}
    ${DIM}# Normal install${RESET}
    ${CYAN}curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh${RESET}

    ${DIM}# Preview changes${RESET}
    ${CYAN}curl -fsSL ... | sh -s -- --dry-run${RESET}

    ${DIM}# Non-interactive install${RESET}
    ${CYAN}curl -fsSL ... | sh -s -- --yes${RESET}

    ${DIM}# Custom location${RESET}
    ${CYAN}DOTFILES_DIR="\$HOME/src/dotfiles" curl -fsSL ... | sh${RESET}
EOF
}

# =============================================================================
# Parse Arguments
# =============================================================================
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
    -h | --help)
      usage
      exit 0
      ;;
    *)
      die "Unknown option: $1 (use --help)"
      ;;
  esac
  shift
done

need_cmd git

# =============================================================================
# Core Functions
# =============================================================================
run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    dry_run_msg "$*"
    return 0
  fi
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
  _name="$(basename "$_dest")"
  _short_dest="$(short_path "$_dest")"
  _short_src="$(short_path "$_src")"

  progress "$_name"

  # Skip if source doesn't exist (optional config)
  if [ ! -e "$_src" ]; then
    skip "Source not found: $_short_src ${DIM}(skipping)${RESET}"
    return 0
  fi

  # Already correct?
  if [ -e "$_dest" ] || [ -L "$_dest" ]; then
    _src_r="$(realpath_compat "$_src")"
    _dest_r="$(realpath_compat "$_dest")"
    if [ "$_src_r" = "$_dest_r" ]; then
      ok_msg "$_short_dest"
      return 0
    fi
  fi

  # Ensure parent dir exists
  _parent="$(dirname "$_dest")"
  [ -d "$_parent" ] || run mkdir -p "$_parent"

  # Prompt when destination exists
  if [ -e "$_dest" ] || [ -L "$_dest" ]; then
    if ! confirm_update "$_dest"; then
      skip "Skipped: $_short_dest"
      return 0
    fi
  fi

  # Backup existing
  if [ "$NO_BACKUP" -eq 0 ] && ([ -e "$_dest" ] || [ -L "$_dest" ]); then
    _bk="$(backup_path "$_dest" "$_ts")"
    _bk_parent="$(dirname "$_bk")"
    [ -d "$_bk_parent" ] || run mkdir -p "$_bk_parent"
    backup_msg "$(short_path "$_dest") ${ICON_ARROW} $(short_path "$_bk")"
    run mv "$_dest" "$_bk"
  elif [ -e "$_dest" ] || [ -L "$_dest" ]; then
    if [ "$FORCE" -ne 1 ]; then
      die "Destination exists (use --force or keep backup enabled): $_dest"
    fi
    warn "Removing: $_short_dest"
    run rm -rf "$_dest"
  fi

  link_msg "$_short_dest" "$_short_src"
  run ln -s "$_src" "$_dest"
}

# =============================================================================
# Main Installation
# =============================================================================
print_header "${ICON_ROCKET} Dotfiles Installer"

printf "\n"
info "Repository: ${BOLD}$REPO_URL${RESET}"
info "Branch:     ${BOLD}$BRANCH${RESET}"
info "Install to: ${BOLD}$(short_path "$DOTFILES_DIR")${RESET}"

if [ "$DRY_RUN" -eq 1 ]; then
  printf "\n"
  warn "${BOLD}DRY RUN MODE${RESET} - No changes will be made"
fi

# =============================================================================
# Clone or Update Repository
# =============================================================================
print_section "${ICON_GIT} Repository Setup"

if [ ! -d "$DOTFILES_DIR" ]; then
  info "Cloning repository..."
  run git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$DOTFILES_DIR"
  success "Cloned to $(short_path "$DOTFILES_DIR")"
else
  [ -d "$DOTFILES_DIR/.git" ] || die "DOTFILES_DIR exists but is not a git repo: $DOTFILES_DIR"
  if [ "$NO_UPDATE" -eq 0 ]; then
    if confirm "Pull latest changes into $(short_path "$DOTFILES_DIR")?"; then
      info "Updating repository..."
      run git -C "$DOTFILES_DIR" fetch --prune origin
      run git -C "$DOTFILES_DIR" checkout "$BRANCH"
      run git -C "$DOTFILES_DIR" pull --ff-only
      success "Repository updated"
    else
      skip "Repository update skipped (user declined)"
    fi
  else
    skip "Repository update skipped (--no-update)"
  fi
fi

TS="$(timestamp)"

# =============================================================================
# Create Symlinks
# =============================================================================
print_section "${ICON_FOLDER} Creating Symlinks"

# Ensure XDG config home exists
run mkdir -p "$HOME/.config"

# Count total items
# 5 root + 9 XDG configs + up to 8 editor settings (4 apps × 2 files) = 22
set_total_items 22

# Root dotfiles
link_item "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv" "$TS"
link_item "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc" "$TS"
link_item "$DOTFILES_DIR/.zprofile" "$HOME/.zprofile" "$TS"
link_item "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig" "$TS"
link_item "$DOTFILES_DIR/.commit_template" "$HOME/.commit_template" "$TS"

# XDG configs (link individual apps, not ~/.config as a whole)
link_item "$DOTFILES_DIR/.config/zsh" "$HOME/.config/zsh" "$TS"
link_item "$DOTFILES_DIR/.config/sheldon" "$HOME/.config/sheldon" "$TS"
link_item "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim" "$TS"
link_item "$DOTFILES_DIR/.config/wezterm" "$HOME/.config/wezterm" "$TS"
link_item "$DOTFILES_DIR/.config/mise" "$HOME/.config/mise" "$TS"
link_item "$DOTFILES_DIR/.config/karabiner" "$HOME/.config/karabiner" "$TS"
link_item "$DOTFILES_DIR/.config/ghostty" "$HOME/.config/ghostty" "$TS"
link_item "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml" "$TS"
link_item "$DOTFILES_DIR/.config/fish" "$HOME/.config/fish" "$TS"

# Editor settings (macOS)
if [ "$(uname -s 2> /dev/null || echo unknown)" = "Darwin" ]; then
  VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
  VSCODE_INSIDERS_USER_DIR="$HOME/Library/Application Support/Code - Insiders/User"
  CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
  VSCODIUM_USER_DIR="$HOME/Library/Application Support/VSCodium/User"

  SETTINGS_SRC="$DOTFILES_DIR/.vscode/settings.json"
  KEYBINDINGS_SRC="$DOTFILES_DIR/.vscode/keybindings.json"

  # Only apply when the app's data dir already exists (avoid creating dirs for apps not installed)
  if [ -d "$VSCODE_USER_DIR" ]; then
    link_item "$SETTINGS_SRC" "$VSCODE_USER_DIR/settings.json" "$TS"
    link_item "$KEYBINDINGS_SRC" "$VSCODE_USER_DIR/keybindings.json" "$TS"
  else
    skip "VS Code not detected (${DIM}skipping settings.json, keybindings.json${RESET})"
  fi

  if [ -d "$VSCODE_INSIDERS_USER_DIR" ]; then
    link_item "$SETTINGS_SRC" "$VSCODE_INSIDERS_USER_DIR/settings.json" "$TS"
    link_item "$KEYBINDINGS_SRC" "$VSCODE_INSIDERS_USER_DIR/keybindings.json" "$TS"
  else
    skip "VS Code Insiders not detected (${DIM}skipping settings.json, keybindings.json${RESET})"
  fi

  if [ -d "$CURSOR_USER_DIR" ]; then
    link_item "$SETTINGS_SRC" "$CURSOR_USER_DIR/settings.json" "$TS"
    link_item "$KEYBINDINGS_SRC" "$CURSOR_USER_DIR/keybindings.json" "$TS"
  else
    skip "Cursor not detected (${DIM}skipping settings.json, keybindings.json${RESET})"
  fi

  if [ -d "$VSCODIUM_USER_DIR" ]; then
    link_item "$SETTINGS_SRC" "$VSCODIUM_USER_DIR/settings.json" "$TS"
    link_item "$KEYBINDINGS_SRC" "$VSCODIUM_USER_DIR/keybindings.json" "$TS"
  else
    skip "VSCodium not detected (${DIM}skipping settings.json, keybindings.json${RESET})"
  fi
else
  skip "Non-macOS detected (${DIM}skipping editor settings${RESET})"
fi

# =============================================================================
# Summary
# =============================================================================
print_section "${ICON_CHECK} Installation Complete"

success "Dotfiles installed successfully!"

if [ "$NO_BACKUP" -eq 0 ]; then
  printf "\n"
  info "Backup location: ${DIM}$(short_path "$BACKUP_ROOT/$TS")${RESET}"
fi

printf "\n"
printf "${DIM}%s${RESET}\n" "To apply changes, restart your shell or run:"
printf "  ${CYAN}source ~/.zshrc${RESET}\n"
printf "\n"
