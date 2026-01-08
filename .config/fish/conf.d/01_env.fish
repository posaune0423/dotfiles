#---------------------------
# Environment Variables
#---------------------------
# Equivalent to ~/.zshenv settings
# This file is sourced early via conf.d
#---------------------------

#---------------------------
# Language & Locale
#---------------------------
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

#---------------------------
# Editor Defaults
#---------------------------
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less

#---------------------------
# XDG Base Directory
#---------------------------
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CACHE_HOME $HOME/.cache

#---------------------------
# Small UX Defaults
#---------------------------
set -gx CLICOLOR 1
set -gx LSCOLORS gxfxcxdxbxegedabagacad

#---------------------------
# Tool Roots
#---------------------------
set -gx GOPATH $HOME/go
set -gx PNPM_HOME $HOME/Library/pnpm

#---------------------------
# Homebrew Settings
#---------------------------
set -gx HOMEBREW_CASK_OPTS --appdir=/Applications
# Prevent accidentally installing version-managed tools via Homebrew
set -gx HOMEBREW_FORBIDDEN_FORMULAE "node python python3 pip npm pnpm yarn claude ruby go openjdk bun deno"

#---------------------------
# Starknet RPC (Optional)
#---------------------------
set -gx STARKNET_RPC_URL https://starknet-mainnet.public.blastapi.io
