# dotfiles

Modern, modular dotfiles configuration inspired by [Takuya Matsuyama](https://github.com/craftzdog/dotfiles-public), optimized for macOS development environments.

## ✨ Features

- **🔧 Modular Zsh Configuration**: Clean, organized shell setup with automatic loading
- **🚀 mise Integration**: All language runtimes and CLI tools managed via [mise](https://mise.jdx.dev/)
- **🎨 Beautiful Prompt**: Starship prompt with Git integration
- **⚡ Performance Optimized**: Fast startup with PATH deduplication
- **🛠️ Neovim Ready**: Modern Neovim configuration with Lua
- **🎯 XDG Base Directory**: Follows XDG standards for clean home directory
- **🔄 Easy Setup**: One-command installation with backup support
- **🔒 Safe Defaults**: `HOMEBREW_FORBIDDEN_FORMULAE` prevents accidental tool overwrites

## 📁 Project Structure

```
dotfiles/
├── install.sh                  # Safe installer/updater (curl | sh)
├── .zshenv                     # Environment variables & PATH setup
├── .zprofile                   # Login shell configuration
├── .zshrc                      # Interactive shell configuration
├── .gitconfig                  # Git configuration
└── .config/                    # Application configurations
    ├── zsh/                    # Modular Zsh configurations
    │   ├── core.zsh            # History, options, basic settings
    │   ├── completion.zsh      # Standard zsh completion
    │   ├── aliases.zsh         # Command aliases
    │   ├── functions.zsh       # Custom functions
    │   ├── tools.zsh           # Development tools setup
    │   ├── prompt.zsh          # Starship prompt initialization
    │   └── plugins/            # Zsh plugins
    │       ├── autocomplete.zsh      # zsh-autocomplete (optional)
    │       ├── autosuggestions.zsh   # zsh-autosuggestions
    │       └── syntax-highlighting.zsh
    ├── mise/                   # mise version manager config
    │   └── config.toml         # Tool versions & CLI tools
    ├── nvim/                   # Neovim configuration
    │   ├── init.lua
    │   └── lua/
    │       ├── config/         # Core config (keymaps, options, etc.)
    │       ├── plugins/        # Plugin configurations
    │       └── util/           # Utility modules
    ├── wezterm/                # WezTerm terminal config
    │   ├── init.lua
    │   ├── appearance.lua
    │   ├── font.lua
    │   ├── keys.lua
    │   └── events.lua
    ├── karabiner/              # Karabiner-Elements config
    │   └── karabiner.json
    ├── ghosty/                 # Ghostty terminal config
    │   └── config
    └── starship.toml           # Starship prompt configuration
```

## 🚀 Quick Start

### Prerequisites

- **macOS** (tested on macOS 15.0+)
- **Homebrew** installed
- **Git** configured

### Installation

#### One-liner (recommended)

This will clone/pull into `~/.dotfiles`, **backup existing files**, then symlink configs into your home directory.

```bash
curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh
```

#### Dry-run first (safe preview)

```bash
curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh -s -- --dry-run
```

#### Interactive yes/no prompts (default on update)

When the repo already exists, the installer will ask before pulling and before replacing existing dotfiles.

If you want to skip prompts (CI / scripts), use:

```bash
curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh -s -- --yes
```

#### Local usage (when already cloned)

```bash
sh ./install.sh --no-update
```

## 🛠️ Configuration Details

### Zsh Configuration Loading Order

The shell configuration follows a specific load order:

1. **`.zshenv`** - Sourced by all Zsh invocations (interactive/non-interactive):
   - PATH helper functions (`path_prepend`, `path_append`) with deduplication
   - XDG Base Directory exports
   - Editor/locale defaults
   - mise shims PATH setup

2. **`.zprofile`** - Login shell only:
   - GUI app environment via `launchctl setenv`
   - One-time runtime configurations

3. **`.zshrc`** - Interactive shells. Loads modules from `~/.config/zsh/` in this order:
   - `core.zsh` - History, options
   - `completion.zsh` OR `plugins/autocomplete.zsh` (choose one)
   - `plugins/autosuggestions.zsh`
   - `plugins/syntax-highlighting.zsh`
   - `aliases.zsh`
   - `functions.zsh`
   - `tools.zsh`
   - `prompt.zsh` - Starship (must be last)

### Version Management with mise

All language runtimes and CLI tools are managed via **mise** (not Homebrew). Configuration in `.config/mise/config.toml`:

#### Language Runtimes

| Runtime | Command |
|---------|---------|
| Node.js | `node`, `npm` |
| Python | `python`, `python3` |
| Ruby | `ruby`, `gem` |
| Go | `go` |
| Java | `java`, `javac` |
| Bun | `bun` |
| Deno | `deno` |

#### CLI Tools (partial list)

| Category | Tools |
|----------|-------|
| **File Operations** | `bat`, `eza`, `fd`, `ripgrep`, `yazi`, `zoxide` |
| **Git Tools** | `gh`, `lazygit`, `delta`, `difftastic`, `ghq` |
| **Text Processing** | `jq`, `sd`, `choose` |
| **System Monitoring** | `bottom`, `procs`, `dust`, `gping` |
| **Search & Navigation** | `fzf`, `peco`, `mcfly` |
| **Development** | `neovim`, `tmux`, `zellij`, `just`, `watchexec` |
| **Cloud & Infra** | `aws`, `terraform`, `docker-cli`, `act` |
| **Code Quality** | `biome`, `buf` |

> **Note**: `HOMEBREW_FORBIDDEN_FORMULAE` is set to prevent accidentally installing version-managed tools via Homebrew.

### Editor Configuration

- **Neovim**: Modern Vim-based editor with Lua configuration
- **Default Editor**: `nvim` set as default `$EDITOR` and `$VISUAL`
- **Pager**: `less` configured for better terminal output

### Prompt Configuration

- **Starship**: Fast, customizable prompt with Git integration
- **Custom Symbols**: Colorful success/error indicators
- **Directory Display**: Smart truncation with repository awareness
- **Cloud Integration**: AWS region and Docker context display

## 📝 Customization

### Adding New Zsh Configurations

1. Create a `.zsh` file in `.config/zsh/`:

```bash
echo 'export MY_CUSTOM_VAR="value"' > ~/.config/zsh/my-config.zsh
```

2. Add it to the `_zsh_configs` array in `.zshrc`:

```bash
typeset -a _zsh_configs=(
  core
  # ... existing configs ...
  my-config    # Add your new config here
  prompt       # Keep prompt last
)
```

### Modifying PATH

Use the built-in helper functions in `.zshenv`:

```bash
# Add to beginning of PATH (higher priority)
path_prepend "/my/custom/bin"

# Add to end of PATH (lower priority)
path_append "/my/other/bin"
```

### Adding New Tools

Add tools to `.config/mise/config.toml` (not Homebrew for version-managed software):

```toml
[tools]
my-tool = "latest"
"npm:my-npm-tool" = "latest"
"pipx:my-python-tool" = "latest"
```

Then run:

```bash
mise install
```

### Starship Prompt

Edit `~/.config/starship.toml` to customize your prompt. See [Starship documentation](https://starship.rs/config/) for options.

## 🔧 Troubleshooting

### Slow Shell Startup

1. Check which tools are being initialized:

```bash
zsh -xvs
```

2. Review mise shim loading in `.zshenv`

### GUI Applications Can't Find Tools

The `.zprofile` handles GUI app environment setup. If needed, restart or run:

```bash
source ~/.zprofile
```

### PATH Issues

Check PATH deduplication is working:

```bash
echo $PATH | tr ':' '\n' | sort | uniq -d
```

### mise Not Working

Ensure mise is installed and shims are on PATH:

```bash
# Check mise installation
mise --version

# Verify shims path
echo $PATH | tr ':' '\n' | grep mise
```

## 🆘 Legacy Tool Setup

If you need additional tools mentioned in the original README:

### dein.vim (Vim Plugin Manager)

```bash
mkdir -p ~/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s ~/.cache/dein
```

### Python3 Support for Vim Plugins

```bash
pip3 install --user pynvim
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b my-feature`
3. Commit your changes: `git commit -am 'Add feature'`
4. Push to the branch: `git push origin my-feature`
5. Submit a pull request

## ⚖️ License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Takuya Matsuyama](https://github.com/craftzdog/dotfiles-public) for the original inspiration
- [Starship](https://starship.rs/) for the amazing prompt
- [mise](https://mise.jdx.dev/) for unified version management
- The open source community for all the amazing tools
