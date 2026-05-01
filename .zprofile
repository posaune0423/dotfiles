# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh"

# .zprofile - zsh login shell initialization
# Runs once per login (e.g. Terminal/iTerm default on macOS).
# PATH for common dev tools lives in ~/.config/zsh/path-exports.zsh (sourced from ~/.zshenv).

# --------------------------
# Build / toolchain environment
# --------------------------
export HOMEBREW_CASK_OPTS="${HOMEBREW_CASK_OPTS:---appdir=/Applications}"
#
# NOTE: mise shims and shared PATH are built in ~/.zshenv via path-exports.zsh.

# --------------------------
# User-provided env scripts (may mutate PATH)
# --------------------------
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -f "$HOME/.starkli/env" ]] && source "$HOME/.starkli/env"
# Deno is now managed by mise, so .deno/env is not needed
[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

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
  launchctl setenv CLOUDSDK_PYTHON "$CLOUDSDK_PYTHON" 2> /dev/null
  launchctl setenv CLOUDSDK_GSUTIL_PYTHON "$CLOUDSDK_GSUTIL_PYTHON" 2> /dev/null

  [[ -n "$GOPATH" ]] && launchctl setenv GOPATH "$GOPATH" 2> /dev/null
fi

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh"
