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
path_prepend "$HOME/bin"
path_prepend "/usr/local/bin"

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
path_prepend "/opt/homebrew/opt/python@3.13/libexec/bin"

# Ruby
path_prepend "$HOME/.rbenv/bin"

# Go
export GOPATH="$HOME/go"
path_append "$GOPATH/bin"

# Node.js ecosystem
export NVM_DIR="$HOME/.nvm"
export PNPM_HOME="$HOME/Library/pnpm"
path_append "$PNPM_HOME"

# ASDF version manager
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
path_prepend "${ASDF_DATA_DIR}/shims"

#---------------------------
# Specialized Development Tools
#---------------------------
# LM Studio CLI
path_append "$HOME/.cache/lm-studio/bin"

#---------------------------
# Performance & Security
#---------------------------
# Skip global compinit for faster startup
skip_global_compinit=1
