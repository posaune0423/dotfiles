# This file is sourced by *every* zsh invocation (interactive/non-interactive,
# login/non-login). Keep it lightweight:
# - OK: simple `export` statements
# - Avoid: PATH mass-editing, `eval`, `source` of large scripts, and any output

# --------------------------
# PATH (safe + de-duplicated)
# --------------------------
# PATH重複を防ぐヘルパー関数
path_prepend() {
  [[ -d "$1" ]] && case ":$PATH:" in
  *":$1:"*) ;;
  *) export PATH="$1:$PATH" ;;
  esac
}

path_append() {
  [[ -d "$1" ]] && case ":$PATH:" in
  *":$1:"*) ;;
  *) export PATH="$PATH:$1" ;;
  esac
}

# --------------------------
# Nix paths (managed by nix-darwin)
# --------------------------
# nix-darwin places binaries here; keep it at the front.
path_prepend "/run/current-system/sw/bin"
path_prepend "$HOME/.nix-profile/bin"

# System fallback
path_prepend "/usr/local/bin"
path_prepend "$HOME/bin"

# --------------------------
# Language & locale
# --------------------------
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
export LANG="${LANG:-en_US.UTF-8}"

# --------------------------
# Editor defaults
# --------------------------
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"
export PAGER="${PAGER:-less}"

# --------------------------
# XDG Base Directory
# --------------------------
# Force XDG_CONFIG_HOME to the standard location.
# This repo is for git-managing dotfiles; runtime configs should live under ~/.config.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# --------------------------
# Small UX defaults (safe)
# --------------------------
export CLICOLOR="${CLICOLOR:-1}"
export LSCOLORS="${LSCOLORS:-gxfxcxdxbxegedabagacad}"

# --------------------------
# Tool roots (consumed by ~/.zshrc modules)
# --------------------------
export GOPATH="${GOPATH:-$HOME/go}"
export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"

# Convenience PATH entries that are cheap and widely useful
path_append "$PNPM_HOME"
