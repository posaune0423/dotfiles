# This file is sourced by *every* zsh invocation (interactive/non-interactive,
# login/non-login). Keep it lightweight:
# - OK: simple `export` statements, tiny helpers, one `source` of path-exports
# - Avoid: `eval`, `source` of large scripts, and any output

# --------------------------
# PATH helpers (used by ~/.config/zsh/path-exports.zsh)
# --------------------------
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
# Tool roots (must be set before path-exports)
# --------------------------
export GOPATH="${GOPATH:-$HOME/go}"
export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"

# --------------------------
# PATH entries (modular)
# --------------------------
[[ -r "$HOME/.config/zsh/path-exports.zsh" ]] && source "$HOME/.config/zsh/path-exports.zsh"

# --------------------------
# XDG Base Directory
# --------------------------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

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
# Small UX defaults (safe)
# --------------------------
export CLICOLOR="${CLICOLOR:-1}"
export LSCOLORS="${LSCOLORS:-gxfxcxdxbxegedabagacad}"

# Keep Google Cloud CLI on a mise-managed Python that both gcloud and gsutil support.
export CLOUDSDK_PYTHON="${CLOUDSDK_PYTHON:-$HOME/.local/share/mise/installs/python/3.13.13/bin/python3.13}"
export CLOUDSDK_GSUTIL_PYTHON="${CLOUDSDK_GSUTIL_PYTHON:-$CLOUDSDK_PYTHON}"

# HOMEBREW_FORBIDDEN_FORMULAEを設定して、不要なパッケージをインストールしないようにする
# Version-managed tools are added to prevent accidental Homebrew installation
export HOMEBREW_FORBIDDEN_FORMULAE="node python python3 pip npm pnpm yarn claude ruby go openjdk bun deno"
