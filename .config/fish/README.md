# Fish Shell Configuration

Modular fish shell configuration mirroring the zsh setup.

## Directory Structure

```
.config/fish/
├── config.fish          # Main entry point (interactive shell settings)
├── conf.d/              # Auto-loaded configuration (alphabetical order)
│   ├── 00_kiro_pre.fish   # Kiro CLI pre-hook
│   ├── 01_env.fish        # Environment variables
│   ├── 02_path.fish       # PATH configuration
│   ├── 03_tools.fish      # Tool initialization (mise, cargo, etc.)
│   ├── 04_completions_path.fish # Adds local completions directory
│   ├── 98_aliases.fish    # Shell aliases
│   ├── 99_kiro_post.fish  # Kiro CLI post-hook
│   └── z.fish             # z directory jumping (fisher plugin)
├── functions/           # Custom functions (lazy-loaded)
│   ├── mkcd.fish          # Create directory and cd into it
│   ├── ff.fish            # Quick file search
│   ├── cpc.fish           # Copy file content to clipboard
│   ├── extract.fish       # Extract various archive formats
│   ├── cat.fish           # Enhanced cat (bat + viu for images)
│   ├── y.fish             # Yazi file manager wrapper
│   └── __z*.fish          # z plugin internals
│   └── update_completions.fish # Generate/update completions
├── completions/         # Command completions
│   └── fisher.fish        # Fisher completion
├── fish_plugins         # Fisher plugin list
└── fish_variables       # Universal variables (auto-managed)
```

## Configuration Loading Order

Fish automatically loads files in this order:

1. `conf.d/*.fish` - Sorted alphabetically
2. `config.fish` - Main configuration
3. `functions/*.fish` - Lazy-loaded on first use

## Plugin Management

Plugins are managed via [fisher](https://github.com/jorgebucaran/fisher).

### Install fisher

```fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

### Update plugins

```fish
fisher update
```

### Current plugins

- `jorgebucaran/fisher` - Plugin manager
- `jethrokuan/z` - Directory jumping (like zsh-z)
- `PatrickF1/fzf.fish` - fzf integration

## Zsh Configuration Mapping

| Zsh File | Fish Equivalent |
|----------|-----------------|
| `.zshenv` | `conf.d/01_env.fish`, `conf.d/02_path.fish` |
| `.zprofile` | `conf.d/03_tools.fish` |
| `.zshrc` | `config.fish` |
| `.config/zsh/aliases.zsh` | `conf.d/98_aliases.fish` |
| `.config/zsh/functions.zsh` | `functions/*.fish` |
| `.config/zsh/tools.zsh` | `conf.d/03_tools.fish` |
| `.config/zsh/prompt.zsh` | `config.fish` (starship init) |
| sheldon plugins | fisher plugins |

## Key Differences from Zsh

- **No need for `export`**: Use `set -gx VAR value`
- **PATH handling**: Use `fish_add_path` (auto-deduplicates)
- **Aliases**: Same syntax, but functions are preferred
- **Syntax**: `if ... end` instead of `if ... fi`, `$argv` instead of `$@`
- **No need for `source ~/.config/fish/config.fish`**: Use `exec fish` or just open new terminal
