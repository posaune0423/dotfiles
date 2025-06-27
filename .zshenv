#---------------------------
# PATH Helper Function
#---------------------------
# PATH重複を防ぐヘルパー関数
path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

path_append() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$PATH:$1" ;;
  esac
}

#---------------------------
# Basic PATH Settings
#---------------------------
# Homebrew (must be first for other tools to work)
path_prepend "/opt/homebrew/bin"
path_prepend "/opt/homebrew/sbin"
path_prepend "/usr/local/bin"
path_prepend "$HOME/bin"

# Dotfiles bin directory
path_prepend "$HOME/Private/posaune0423/dotfiles/bin"

#---------------------------
# Language & Locale Settings
#---------------------------
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#---------------------------
# Editor Settings
#---------------------------
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

#---------------------------
# XDG Base Directory Specification
#---------------------------
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

#---------------------------
# Development Tools - Build Systems
#---------------------------
# OpenSSL
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

# Homebrew
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

#---------------------------
# Development Tools - Language Runtimes
#---------------------------
# Java
path_prepend "/usr/local/opt/openjdk@11/bin"

# Python
export PYENV_ROOT="$HOME/.pyenv"
path_prepend "$PYENV_ROOT/bin"
# Initialize pyenv PATH (must be in .zshenv for GUI apps)
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi
path_prepend "/opt/homebrew/opt/python@3.13/libexec/bin"

# Ruby
export RBENV_ROOT="$HOME/.rbenv"
path_prepend "$RBENV_ROOT/bin"

# Go
export GOPATH="$HOME/go"
# Set GOROOT only if golang is installed via Homebrew
if [[ -d "/opt/homebrew/opt/go/libexec" ]]; then
  export GOROOT="/opt/homebrew/opt/go/libexec"
  path_append "$GOROOT/bin"
fi
path_append "$GOPATH/bin"

# Node.js ecosystem
export NVM_DIR="$HOME/.nvm"
export PNPM_HOME="$HOME/Library/pnpm"
path_append "$PNPM_HOME"

# ASDF version manager
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
path_prepend "${ASDF_DATA_DIR}/shims"

# Bun
export BUN_INSTALL="$HOME/.bun"
path_prepend "$BUN_INSTALL/bin"

# Deno
export DENO_INSTALL="$HOME/.deno"
path_prepend "$DENO_INSTALL/bin"

#---------------------------
# Specialized Development Tools
#---------------------------
# LM Studio CLI
path_append "$HOME/.cache/lm-studio/bin"

# Starkli
export STARKNET_RPC_URL="https://starknet-mainnet.public.blastapi.io"

#---------------------------
# Performance & Security
#---------------------------
# Skip global compinit for faster startup
skip_global_compinit=1
