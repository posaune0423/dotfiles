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

# OpenSSL (only if you still want these globally)
export LDFLAGS="${LDFLAGS:--L/usr/local/opt/openssl/lib}"
export CPPFLAGS="${CPPFLAGS:--I/usr/local/opt/openssl/include}"

# --------------------------
# Language runtimes / package managers
# --------------------------
# Java
path_prepend "/usr/local/opt/openjdk@11/bin"

# Python
path_prepend "$PYENV_ROOT/bin"
if [[ -d "$PYENV_ROOT" ]] && command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi
path_prepend "/opt/homebrew/opt/python@3.13/libexec/bin"

# Ruby
path_prepend "$RBENV_ROOT/bin"

# Go
if [[ -d "/opt/homebrew/opt/go/libexec" ]]; then
  export GOROOT="/opt/homebrew/opt/go/libexec"
  path_append "$GOROOT/bin"
fi
path_append "$GOPATH/bin"

# asdf shims
path_prepend "${ASDF_DATA_DIR}/shims"

# Bun / Deno
path_prepend "$BUN_INSTALL/bin"
path_prepend "$DENO_INSTALL/bin"

# --------------------------
# User-provided env scripts
# --------------------------
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -f "$HOME/.starkli/env" ]] && source "$HOME/.starkli/env"
[[ -f "$HOME/.deno/env" ]] && source "$HOME/.deno/env"
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
  launchctl setenv PATH "$PATH" 2>/dev/null
  launchctl setenv LANG "$LANG" 2>/dev/null
  launchctl setenv LC_ALL "$LC_ALL" 2>/dev/null
  launchctl setenv EDITOR "$EDITOR" 2>/dev/null
  launchctl setenv VISUAL "$VISUAL" 2>/dev/null

  [[ -n "$GOPATH" ]] && launchctl setenv GOPATH "$GOPATH" 2>/dev/null
  [[ -n "$GOROOT" ]] && launchctl setenv GOROOT "$GOROOT" 2>/dev/null
  [[ -n "$PYENV_ROOT" ]] && launchctl setenv PYENV_ROOT "$PYENV_ROOT" 2>/dev/null
  [[ -n "$RBENV_ROOT" ]] && launchctl setenv RBENV_ROOT "$RBENV_ROOT" 2>/dev/null
  [[ -n "$NVM_DIR" ]] && launchctl setenv NVM_DIR "$NVM_DIR" 2>/dev/null
fi

# --------------------------
# Kiro CLI post block. Keep at the bottom of this file.
# --------------------------
[[ -f "$HOME/Library/Application Support/kiro-cli/shell/profile.post.bash" ]] && source "$HOME/Library/Application Support/kiro-cli/shell/profile.post.bash"
