# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **Nix-first** macOS dotfiles repository. All CLI tools, language runtimes, and system configuration are managed declaratively via **nix-darwin + home-manager** flakes.

Application configs (Neovim, WezTerm, Karabiner, Starship, Ghostty) and shell configuration (modular Zsh with sheldon) are symlinked by home-manager.

## Installation

```bash
# One-liner install (installs Nix, clones repo, runs nix-darwin switch)
curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh

# Preview changes without making them
curl -fsSL ... | sh -s -- --dry-run

# After initial setup, apply changes with:
nix run .#switch
```

## Architecture

### Nix Structure

```
flake.nix                 # Entry point: inputs + outputs
├── nix/darwin/default.nix    # nix-darwin: system packages, macOS settings
└── nix/home/default.nix      # home-manager: dotfile symlinks
```

**Key files:**
- `flake.nix` - Defines inputs (nixpkgs, nix-darwin, home-manager) and outputs (darwinConfigurations, apps)
- `nix/darwin/default.nix` - System-level packages (`environment.systemPackages`) and macOS defaults (`system.defaults`)
- `nix/home/default.nix` - Dotfile symlinks via `home.file` and `xdg.configFile`

### Zsh Configuration Loading Order

The shell configuration follows a specific load order defined in `.zshrc`:

1. **`.zshenv`** - Sourced by all Zsh invocations. Contains:
   - PATH helper functions (`path_prepend`, `path_append`) with deduplication
   - Nix paths (`/run/current-system/sw/bin`, `~/.nix-profile/bin`)
   - XDG Base Directory exports
   - Editor/locale defaults

2. **`.zprofile`** - Login shell only. Handles GUI app environment via `launchctl setenv`

3. **`.zshrc`** - Interactive shells. Loads modules from `~/.config/zsh/` in this order:
   - `core.zsh` - History, options
   - `completion.zsh` - Zsh completion with Nix site-functions
   - `aliases.zsh`
   - `functions.zsh`
   - `tools.zsh` - Tool initialization (zoxide, atuin, mcfly)
   - `prompt.zsh` - Starship (must be last)
   - **sheldon plugins** - zsh-autosuggestions, zsh-syntax-highlighting

### Plugin Management with sheldon

Zsh plugins are managed via [sheldon](https://github.com/rossmacarthur/sheldon). Configuration in `.config/sheldon/plugins.toml`:
- `zsh-autosuggestions` - Fish-like command autosuggestions
- `zsh-syntax-highlighting` - Fish-like syntax highlighting

### Dotfile Symlinks (via home-manager)

home-manager automatically creates symlinks on `nix run .#switch`:
- Root dotfiles: `.zshenv`, `.zshrc`, `.zprofile`, `.gitconfig`
- XDG configs: `zsh/`, `sheldon/`, `nvim/`, `wezterm/`, `karabiner/`, `ghosty/`, `starship.toml`

## Key Conventions

- **Adding new tools**: Edit `nix/darwin/default.nix` → `environment.systemPackages`, then `nix run .#switch`
- **New Zsh modules**: Create `.zsh` files in `.config/zsh/` and add to `_zsh_configs` array in `.zshrc`
- **macOS settings**: Edit `system.defaults` in `nix/darwin/default.nix`
- **GUI environment vars**: Add to `.zprofile` with `launchctl setenv` for macOS app access

## Common Commands

```bash
nix run .#switch    # Apply all configuration changes
nix run .#build     # Build without applying (dry run)
nix run .#update    # Update flake.lock dependencies
nix run .#check     # Validate flake
```

## CI

GitHub Actions (`.github/workflows/ci.yml`) runs on every push:
- `nix flake check` - Validates flake
- `nix build .#darwinConfigurations.mac.system` - Builds full configuration
