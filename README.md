# dotfiles

Modern, modular dotfiles configuration inspired by [Takuya Matsuyama](https://github.com/craftzdog/dotfiles-public), optimized for macOS development environments.

## ✨ Features

- **🔧 Modular Zsh Configuration**: Clean, organized shell setup with automatic loading
- **🚀 Development Tools Integration**: Support for Python, Node.js, Go, Ruby, Java, and more
- **📦 Package Manager Support**: pyenv, rbenv, nvm, asdf, bun, pnpm integration
- **🎨 Beautiful Prompt**: Starship prompt with Git integration
- **⚡ Performance Optimized**: Fast startup with PATH deduplication
- **🛠️ Neovim Ready**: Modern Neovim configuration included
- **🎯 XDG Base Directory**: Follows XDG standards for clean home directory
- **🔄 Easy Setup**: One-command installation with backup support

## 📁 Project Structure

```
dotfiles/
├── setup_dotfiles.sh          # Automated setup script
├── .zshenv                     # Environment variables & PATH setup
├── .zprofile                   # Login shell configuration
├── .zshrc                      # Interactive shell configuration
├── .gitconfig                  # Git configuration
└── .config/                    # Application configurations
    ├── zsh/                    # Modular Zsh configurations
    │   ├── aliases.zsh         # Command aliases
    │   ├── functions.zsh       # Custom functions
    │   ├── tools.zsh          # Development tools setup
    │   ├── ui.zsh             # UI and prompt configuration
    │   └── zsh-config.zsh     # Core Zsh settings
    ├── nvim/                   # Neovim configuration
    ├── starship.toml          # Starship prompt configuration
    └── ghosty/                # Additional configurations
```

## 🚀 Quick Start

### Prerequisites

- **macOS** (tested on macOS 15.0+)
- **Homebrew** installed
- **Git** configured

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the setup script**
   ```bash
   ./setup_dotfiles.sh
   ```

3. **Restart your terminal** or source the configuration
   ```bash
   source ~/.zshrc
   ```

## 🛠️ Configuration Details

### Zsh Configuration

Our Zsh setup is split into focused modules:

- **`.zshenv`**: Environment variables, PATH management, and tool initialization
- **`.zprofile`**: Login shell configuration and GUI app environment setup
- **`.zshrc`**: Interactive shell setup with modular loading
- **`.config/zsh/`**: Modular configuration files loaded automatically

### Development Tools Support

The configuration automatically detects and configures:

| Tool | Purpose | Configuration |
|------|---------|---------------|
| **Homebrew** | Package manager | Auto-detected, PATH priority |
| **pyenv** | Python version management | Auto-initialization |
| **rbenv** | Ruby version management | Auto-initialization |
| **nvm** | Node.js version management | Directory setup |
| **asdf** | Universal version manager | Shim PATH configuration |
| **bun** | JavaScript runtime & package manager | PATH integration |
| **pnpm** | Fast Node.js package manager | PATH integration |
| **Go** | Go programming language | GOPATH and GOROOT setup |
| **Java** | OpenJDK 11 support | PATH configuration |

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

Create new `.zsh` files in `.config/zsh/` directory:

```bash
echo 'export MY_CUSTOM_VAR="value"' > ~/.config/zsh/my-config.zsh
```

The file will be automatically loaded on next shell startup.

### Modifying PATH

Use the built-in helper functions in `.zshenv`:

```bash
# Add to beginning of PATH (higher priority)
path_prepend "/my/custom/bin"

# Add to end of PATH (lower priority)  
path_append "/my/other/bin"
```

### Starship Prompt

Edit `~/.config/starship.toml` to customize your prompt. See [Starship documentation](https://starship.rs/config/) for options.

## 🔧 Troubleshooting

### Slow Shell Startup

1. Check which tools are being initialized:
   ```bash
   zsh -xvs
   ```

2. Disable unused version managers by commenting them out in `.zshenv`

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

## 🆘 Legacy Tool Setup

If you need the legacy tools mentioned in the original README:

### dein.vim (Vim Plugin Manager)

```bash
mkdir -p ~/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s ~/.cache/dein
```

### Python3 Support for Vim Plugins

```bash
pip3 install --user pynvim
pip install --user pynvim  # Python 2 support
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
- The open source community for all the amazing tools
