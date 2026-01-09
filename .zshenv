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

# Minimal base PATH (Homebrew first)
path_prepend "/opt/homebrew/bin"
path_prepend "/opt/homebrew/sbin"
path_prepend "/usr/local/bin"
path_prepend "$HOME/bin"

# --------------------------
# mise (version manager) shims
# --------------------------
# Ensure mise shims are on PATH for all shells (interactive/non-interactive).
# This is intentionally lightweight and avoids running `eval` here.
path_prepend "${MISE_DATA_DIR:-$HOME/.local/share/mise}/shims"
path_prepend "${MISE_DATA_DIR:-$HOME/.local/share/mise}/bin"

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
# Note: Version management is now handled by mise (see ~/.zshrc)
# Only non-version-manager tool roots are kept here

export GOPATH="${GOPATH:-$HOME/go}"
export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"

# Convenience PATH entries that are cheap and widely useful
path_append "$PNPM_HOME"

# HOMEBREW_FORBIDDEN_FORMULAEを設定して、不要なパッケージをインストールしないようにする
# Version-managed tools are added to prevent accidental Homebrew installation
export HOMEBREW_FORBIDDEN_FORMULAE="node python python3 pip npm pnpm yarn claude ruby go openjdk bun deno"
