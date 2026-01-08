# dotfiles

Modern, declarative macOS dotfiles managed by **Nix** (nix-darwin + home-manager).

Inspired by [Takuya Matsuyama](https://github.com/craftzdog/dotfiles-public), [ryoppippi/dotfiles](https://github.com/ryoppippi/dotfiles), and [shunkakinoki/dotfiles](https://github.com/shunkakinoki/dotfiles).

## Features

- **Nix-first**: All CLI tools, language runtimes, and system configuration managed via Nix flakes
- **Declarative macOS settings**: Key repeat, Dock, Finder, trackpad settings all in code
- **Modular Zsh configuration**: Clean, organized shell setup with [sheldon](https://github.com/rossmacarthur/sheldon) plugin manager
- **Beautiful Prompt**: Starship prompt with Git integration
- **One-command setup**: `nix run .#switch` applies everything
- **CI-verified**: GitHub Actions builds the configuration on every push

## Quick Start

### One-liner Install

```bash
curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh
```

This will:
1. Install Nix (Determinate Systems installer) if not present
2. Clone this repo to `~/.dotfiles`
3. Run `nix-darwin switch` to apply system + home configuration

### Manual Setup

1. **Install Nix** (Determinate Systems installer):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

2. **Clone this repository**:

```bash
git clone https://github.com/posaune0423/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

3. **Apply the configuration**:

```bash
# First time (nix-darwin not yet in PATH)
sudo nix run nix-darwin -- switch --flake .#mac

# After first run
nix run .#switch
```

4. **Restart your shell**:

```bash
exec zsh -l
```

## Daily Usage

```bash
# Apply configuration changes
nix run .#switch

# Update flake inputs (nixpkgs, home-manager, etc.)
nix run .#update

# Build without applying (dry run)
nix run .#build

# Check flake for errors
nix run .#check
```

## Project Structure

```
dotfiles/
├── flake.nix                   # Nix flake entry point
├── flake.lock                  # Locked dependency versions
├── install.sh                  # Bootstrap installer
├── nix/
│   ├── darwin/
│   │   └── default.nix         # nix-darwin: system packages & macOS settings
│   └── home/
│       └── default.nix         # home-manager: dotfile symlinks
├── .zshenv                     # Environment variables & PATH
├── .zprofile                   # Login shell configuration
├── .zshrc                      # Interactive shell configuration
├── .gitconfig                  # Git configuration
└── .config/
    ├── zsh/                    # Modular Zsh configurations
    │   ├── core.zsh            # History, options
    │   ├── completion.zsh      # Completion setup
    │   ├── aliases.zsh         # Command aliases
    │   ├── functions.zsh       # Custom functions
    │   ├── tools.zsh           # Tool initialization (zoxide, atuin)
    │   └── prompt.zsh          # Starship prompt
    ├── sheldon/                # sheldon plugin manager config
    ├── nvim/                   # Neovim configuration
    ├── wezterm/                # WezTerm terminal config
    ├── karabiner/              # Karabiner-Elements config
    ├── ghostty/                # Ghostty terminal config
    └── starship.toml           # Starship prompt configuration
```

## What Gets Installed

### CLI Tools

| Category | Tools |
|----------|-------|
| **File Operations** | bat, eza, fd, ripgrep, fzf, yazi, zoxide |
| **Git Tools** | gh, hub, delta, difftastic, lazygit, ghq |
| **Text Processing** | jq, sd |
| **System Monitoring** | bottom, procs, dust, gping, tokei |
| **Shell** | sheldon, starship, atuin, mcfly |
| **Development** | neovim, tmux, zellij, just, watchexec |
| **Cloud/Infra** | awscli2, terraform, act |

### Language Runtimes

- Node.js, Python, Ruby, Go, Java, Bun, Deno (all via Nixpkgs)

### macOS Settings (via nix-darwin)

- **Keyboard**: Fast key repeat (KeyRepeat=1, InitialKeyRepeat=15), disable press-and-hold
- **Dock**: Auto-hide, no recent apps, minimize to app icon
- **Finder**: Show all extensions, path bar, status bar, list view
- **Trackpad**: Tap to click, right-click
- **Security**: Touch ID for sudo

## Customization

### Adding New Tools

Edit `nix/darwin/default.nix`:

```nix
environment.systemPackages = with pkgs; [
  # ... existing packages ...
  my-new-tool
];
```

Then run `nix run .#switch`.

### Adding New Zsh Configuration

1. Create a `.zsh` file in `.config/zsh/`
2. Add it to `_zsh_configs` array in `.zshrc`

### Modifying macOS Settings

Edit `system.defaults` in `nix/darwin/default.nix`. See [nix-darwin options](https://daiderd.com/nix-darwin/manual/index.html) for available settings.

## CI

GitHub Actions runs on every push to verify the configuration builds:

- `nix flake check` - Validates flake structure
- `nix build .#darwinConfigurations.mac.system` - Builds the full system config

## Troubleshooting

### Slow Shell Startup

Check which tools are being initialized:

```bash
zsh -xvs
```

### PATH Issues

Nix paths should be at the front:

```bash
echo $PATH | tr ':' '\n' | head -5
# Should show:
# /run/current-system/sw/bin
# /Users/<you>/.nix-profile/bin
# ...
```

### Rebuild After Changing Nix Files

Always run after editing `nix/`:

```bash
nix run .#switch
```

## License

This project is open source and available under the [MIT License](LICENSE).

## Acknowledgments

- [ryoppippi/dotfiles](https://github.com/ryoppippi/dotfiles) - Nix flake structure inspiration
- [shunkakinoki/dotfiles](https://github.com/shunkakinoki/dotfiles) - nix-darwin patterns
- [Takuya Matsuyama](https://github.com/craftzdog/dotfiles-public) - Original dotfiles inspiration
- [Starship](https://starship.rs/) - Amazing prompt
- [Determinate Systems](https://determinate.systems/) - Nix installer
