
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh"

# .zprofile - zsh login shell initialization
# Runs once per login (e.g. Terminal/iTerm default on macOS).
# Put PATH construction and one-time setup here.

# --------------------------
# Kiro CLI pre block. Keep at the top of this file.
# --------------------------
[[ -f "$HOME/Library/Application Support/kiro-cli/shell/profile.pre.bash" ]] && source "$HOME/Library/Application Support/kiro-cli/shell/profile.pre.bash"

# --------------------------
# Build / toolchain environment
# --------------------------
export HOMEBREW_CASK_OPTS="${HOMEBREW_CASK_OPTS:---appdir=/Applications}"
#
# NOTE: mise shims are prepended in ~/.zshenv (for all shells).
# Keep ~/.zprofile lightweight.

# --------------------------
# Language runtimes / package managers
# --------------------------
# Note: Version management (Node/Python/Ruby/Go/Java/Bun/Deno) is now handled by mise
# See ~/.zshrc for mise activation

# Go: Keep GOPATH/bin for go install binaries (not version-managed by mise)
path_append "$GOPATH/bin"

# --------------------------
# User-provided env scripts
# --------------------------
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -f "$HOME/.starkli/env" ]] && source "$HOME/.starkli/env"
# Deno is now managed by mise, so .deno/env is not needed
[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# LM Studio CLI (lms)
path_append "$HOME/.cache/lm-studio/bin"

# Solana
path_prepend "$HOME/.local/share/solana/install/active_release/bin"

# Starknet default RPC (optional)
export STARKNET_RPC_URL="${STARKNET_RPC_URL:-https://starknet-mainnet.public.blastapi.io}"

# --------------------------
# GUI Application Environment Variables (macOS)
# --------------------------
# Make environment variables available to GUI applications on macOS
if [[ "$OSTYPE" == darwin* ]]; then
  launchctl setenv PATH "$PATH" 2> /dev/null
  launchctl setenv LANG "$LANG" 2> /dev/null
  launchctl setenv LC_ALL "$LC_ALL" 2> /dev/null
  launchctl setenv EDITOR "$EDITOR" 2> /dev/null
  launchctl setenv VISUAL "$VISUAL" 2> /dev/null

  [[ -n "$GOPATH" ]] && launchctl setenv GOPATH "$GOPATH" 2> /dev/null
fi

# --------------------------
# Kiro CLI post block. Keep at the bottom of this file.
# --------------------------
[[ -f "$HOME/Library/Application Support/kiro-cli/shell/profile.post.bash" ]] && source "$HOME/Library/Application Support/kiro-cli/shell/profile.post.bash"


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh"

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
