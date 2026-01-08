# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS dotfiles repository with modular Zsh and Fish shell configurations. It manages shell configuration, development tools via mise, and application configs (Neovim, WezTerm, Karabiner, Starship, Ghostty).

## Installation

```bash
# One-liner install (clones to ~/.dotfiles, backs up existing files, creates symlinks)
curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh

# Preview changes without making them
curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh -s -- --dry-run

# Local usage (when already cloned)
sh ./install.sh --no-update
```

## Architecture

### Zsh Configuration Loading Order

The shell configuration follows a specific load order defined in `.zshrc`:

1. **`.zshenv`** - Sourced by all Zsh invocations (interactive/non-interactive). Contains:
   - PATH helper functions (`path_prepend`, `path_append`) with deduplication
   - XDG Base Directory exports
   - Editor/locale defaults
   - mise shims PATH setup

2. **`.zprofile`** - Login shell only. Handles GUI app environment via `launchctl setenv`

3. **`.zshrc`** - Interactive shells. Loads modules from `~/.config/zsh/` in this order:
   - `core.zsh` - History, options
   - `completion.zsh` OR `plugins/autocomplete.zsh` (choose one)
   - `aliases.zsh`
   - `functions.zsh`
   - `tools.zsh`
   - `prompt.zsh` - Starship (must be last)
   - **sheldon plugins** - zsh-autosuggestions, zsh-syntax-highlighting (loaded via `eval "$(sheldon source)"`)

### Plugin Management with sheldon

Zsh plugins are managed via [sheldon](https://github.com/rossmacarthur/sheldon), a fast plugin manager written in Rust. Configuration in `.config/sheldon/plugins.toml`:
- `zsh-autosuggestions` - Fish-like command autosuggestions
- `zsh-syntax-highlighting` - Fish-like syntax highlighting
- `zsh-autocomplete` (optional) - Real-time type-ahead completion

### Version Management with mise

All language runtimes and CLI tools are managed via mise (not Homebrew). The configuration in `.config/mise/config.toml` defines:
- Language runtimes: Node.js, Python, Ruby, Go, Java, Bun, Deno
- CLI tools: bat, eza, fd, ripgrep, fzf, lazygit, gh, etc.

`HOMEBREW_FORBIDDEN_FORMULAE` is set to prevent accidentally installing version-managed tools via Homebrew.

### Fish Shell Configuration

Fish configuration mirrors the zsh setup. Files in `.config/fish/`:

1. **`conf.d/*.fish`** - Auto-loaded in alphabetical order:
   - `01_env.fish` - Environment variables
   - `02_path.fish` - PATH configuration (uses `fish_add_path`)
   - `03_tools.fish` - Tool initialization (mise, cargo, etc.)
   - `98_aliases.fish` - Shell aliases

2. **`config.fish`** - Main entry point for interactive shells (Starship prompt)

3. **`functions/*.fish`** - Custom functions (lazy-loaded):
   - `mkcd.fish`, `ff.fish`, `cpc.fish`, `extract.fish`, `cat.fish`, `y.fish`

4. **Plugin Management**: [fisher](https://github.com/jorgebucaran/fisher) via `fish_plugins`

### Symlink Structure

The installer creates symlinks from `~/.dotfiles/` to:
- Root dotfiles: `.zshenv`, `.zshrc`, `.zprofile`, `.gitconfig`
- XDG configs: Individual app directories under `~/.config/` (not the entire `.config` folder)
- Fish config: `.config/fish/`

## Key Conventions

- **PATH management (Zsh)**: Always use `path_prepend` or `path_append` helpers to avoid duplicates
- **PATH management (Fish)**: Use `fish_add_path` which auto-deduplicates
- **New Zsh modules**: Create `.zsh` files in `.config/zsh/` and add to the `_zsh_configs` array in `.zshrc`
- **New Fish configs**: Create `.fish` files in `.config/fish/conf.d/` with numeric prefix for load order
- **New Fish functions**: Create `function_name.fish` in `.config/fish/functions/`
- **New tools**: Add to `.config/mise/config.toml` (not Homebrew for version-managed software)
- **GUI environment vars**: Add to `.zprofile` with `launchctl setenv` for macOS app access
