#!/bin/sh
#
# Dotfiles installer (Nix-first).
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh
#   curl -fsSL ... | sh -s -- --dry-run
#
set -eu

# Best-effort pipefail (not POSIX, but harmless when supported)
if (set -o pipefail) 2>/dev/null; then
  set -o pipefail
fi

# =============================================================================
# Color & Formatting
# =============================================================================
setup_colors() {
  if [ -t 1 ] && [ -n "${TERM:-}" ] && [ "$TERM" != "dumb" ]; then
    BOLD="\033[1m"
    DIM="\033[2m"
    RESET="\033[0m"
    RED="\033[31m"
    GREEN="\033[32m"
    YELLOW="\033[33m"
    BLUE="\033[34m"
    CYAN="\033[36m"
  else
    BOLD="" DIM="" RESET=""
    RED="" GREEN="" YELLOW="" BLUE="" CYAN=""
  fi
}
setup_colors

# =============================================================================
# Icons (Unicode)
# =============================================================================
ICON_CHECK="✓"
ICON_CROSS="✗"
ICON_ARROW="→"
ICON_INFO="ℹ"
ICON_WARN="⚠"
ICON_ROCKET="🚀"
ICON_GIT="🔄"
ICON_NIX="❄️"

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

info() { printf "${CYAN}${ICON_INFO}${RESET}  %s\n" "$*"; }
success() { printf "${GREEN}${ICON_CHECK}${RESET}  ${GREEN}%s${RESET}\n" "$*"; }
warn() { printf "${YELLOW}${ICON_WARN}${RESET}  ${YELLOW}%s${RESET}\n" "$*"; }
err() { printf "${RED}${ICON_CROSS}${RESET}  ${RED}ERROR: %s${RESET}\n" "$*" >&2; }
die() { err "$*"; exit 1; }
dry_run_msg() { printf "${YELLOW}[dry-run]${RESET} %s\n" "$*"; }

short_path() {
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
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
REPO_URL="${REPO_URL:-https://github.com/posaune0423/dotfiles.git}"
BRANCH="${BRANCH:-main}"
HOST="${HOST:-mac}"

usage() {
  cat <<EOF
${BOLD}${BLUE}Dotfiles Installer (Nix-first)${RESET}

${BOLD}USAGE:${RESET}
    curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh

${BOLD}OPTIONS:${RESET}
    ${GREEN}--dry-run${RESET}        Print actions without changing anything
    ${GREEN}--dotfiles-dir${RESET}   Install location (default: \$HOME/.dotfiles)
    ${GREEN}--repo${RESET}           Git repo URL
    ${GREEN}--branch${RESET}         Git branch (default: main)
    ${GREEN}--host${RESET}           nix-darwin host name (default: mac)
    ${GREEN}-h, --help${RESET}       Show this help

${BOLD}WHAT THIS DOES:${RESET}
    1. Install Nix (Determinate Systems installer) if not present
    2. Clone/update this dotfiles repo to ~/.dotfiles
    3. Run nix-darwin switch to apply system + home configuration
EOF
}

# =============================================================================
# Parse Arguments
# =============================================================================
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --dotfiles-dir)
      shift; [ $# -gt 0 ] || die "--dotfiles-dir requires a value"
      DOTFILES_DIR="$1"
      ;;
    --repo)
      shift; [ $# -gt 0 ] || die "--repo requires a value"
      REPO_URL="$1"
      ;;
    --branch)
      shift; [ $# -gt 0 ] || die "--branch requires a value"
      BRANCH="$1"
      ;;
    --host)
      shift; [ $# -gt 0 ] || die "--host requires a value"
      HOST="$1"
      ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" ;;
  esac
  shift
done

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    dry_run_msg "$*"
    return 0
  fi
  "$@"
}

# =============================================================================
# Check Dependencies
# =============================================================================
need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}
need_cmd git

# =============================================================================
# Main Installation
# =============================================================================
print_header "${ICON_ROCKET} Dotfiles Installer (Nix-first)"

printf "\n"
info "Repository: ${BOLD}$REPO_URL${RESET}"
info "Branch:     ${BOLD}$BRANCH${RESET}"
info "Install to: ${BOLD}$(short_path "$DOTFILES_DIR")${RESET}"
info "Host:       ${BOLD}$HOST${RESET}"

if [ "$DRY_RUN" -eq 1 ]; then
  printf "\n"
  warn "${BOLD}DRY RUN MODE${RESET} - No changes will be made"
fi

# =============================================================================
# Step 1: Install Nix (if needed)
# =============================================================================
print_section "${ICON_NIX} Nix Setup"

if command -v nix >/dev/null 2>&1; then
  success "Nix is already installed"
else
  info "Installing Nix (Determinate Systems installer)..."
  if [ "$DRY_RUN" -eq 0 ]; then
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    # Source Nix for current shell
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    success "Nix installed"
  else
    dry_run_msg "curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
  fi
fi

# =============================================================================
# Step 2: Clone or Update Repository
# =============================================================================
print_section "${ICON_GIT} Repository Setup"

if [ ! -d "$DOTFILES_DIR" ]; then
  info "Cloning repository..."
  run git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$DOTFILES_DIR"
  success "Cloned to $(short_path "$DOTFILES_DIR")"
else
  [ -d "$DOTFILES_DIR/.git" ] || die "DOTFILES_DIR exists but is not a git repo: $DOTFILES_DIR"
  info "Updating repository..."
  run git -C "$DOTFILES_DIR" fetch --prune origin
  run git -C "$DOTFILES_DIR" checkout "$BRANCH"
  run git -C "$DOTFILES_DIR" pull --ff-only
  success "Repository updated"
fi

# =============================================================================
# Step 3: Run nix-darwin switch
# =============================================================================
print_section "${ICON_NIX} Applying Nix Configuration"

info "Running nix-darwin switch (this may take a while on first run)..."

if [ "$DRY_RUN" -eq 0 ]; then
  cd "$DOTFILES_DIR"
  # First time: use nix run nix-darwin; afterwards darwin-rebuild is in PATH
  if command -v darwin-rebuild >/dev/null 2>&1; then
    sudo darwin-rebuild switch --flake ".#$HOST"
  else
    sudo nix run nix-darwin -- switch --flake ".#$HOST"
  fi
  success "Configuration applied"
else
  dry_run_msg "cd $DOTFILES_DIR && sudo nix run nix-darwin -- switch --flake .#$HOST"
fi

# =============================================================================
# Summary
# =============================================================================
print_section "${ICON_CHECK} Installation Complete"

success "Dotfiles installed successfully!"

printf "\n"
printf "${DIM}%s${RESET}\n" "To apply future changes, run:"
printf "  ${CYAN}cd $(short_path "$DOTFILES_DIR") && nix run .#switch${RESET}\n"
printf "\n"
printf "${DIM}%s${RESET}\n" "Or restart your shell to pick up PATH changes:"
printf "  ${CYAN}exec zsh -l${RESET}\n"
printf "\n"
