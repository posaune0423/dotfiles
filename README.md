# dotfiles

macOS 向けの dotfiles（XDG 準拠）。Zsh / Fish、[mise](https://mise.jdx.dev/) によるランタイム・CLI 管理、Neovim（LazyVim）、WezTerm、Karabiner、Ghostty、Starship、VS Code / Cursor 設定をまとめています。

## Quick start

### Install

```bash
curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh
```

### Dry-run

```bash
curl -fsSL https://raw.githubusercontent.com/posaune0423/dotfiles/main/install.sh | sh -s -- --dry-run
```

### Local

```bash
sh ./install.sh --no-update
```

## What the installer does

- **clone / update**: `~/.dotfiles`
- **backup**: 既存ファイルを `~/.dotfiles-backup/<timestamp>/...` に退避
- **symlink**: dotfiles をホーム配下へリンク
- **VS Code / Cursor**: macOS で該当ディレクトリが存在する場合のみ `settings.json` をリンク

| source (repo) | destination |
|---|---|
| `.zshenv` | `~/.zshenv` |
| `.zshrc` | `~/.zshrc` |
| `.zprofile` | `~/.zprofile` |
| `.gitconfig` | `~/.gitconfig` |
| `.config/zsh/` | `~/.config/zsh/` |
| `.config/sheldon/` | `~/.config/sheldon/` |
| `.config/mise/` | `~/.config/mise/` |
| `.config/nvim/` | `~/.config/nvim/` |
| `.config/wezterm/` | `~/.config/wezterm/` |
| `.config/starship.toml` | `~/.config/starship.toml` |
| `.config/fish/` | `~/.config/fish/` |
| `.config/karabiner/` | `~/.config/karabiner/` |
| `.config/ghostty/` | `~/.config/ghostty/` |
| `.vscode/settings.json` | `~/Library/Application Support/{Code,Cursor,VSCodium}/User/settings.json`（存在するもののみ） |

## Inventory (plugins / tools)

### Managers

| area | tool | config |
|---|---|---|
| runtimes / CLI | **mise** | `.config/mise/config.toml` |
| zsh plugins | **sheldon** | `.config/sheldon/plugins.toml` |
| fish plugins | **fisher** | `.config/fish/fish_plugins` |
| Neovim plugins | **lazy.nvim (LazyVim)** | `.config/nvim/lazy-lock.json` |
| prompt | **starship** | `.config/starship.toml` |

### Apps / configs

| app | config |
|---|---|
| WezTerm | `.config/wezterm/` |
| Ghostty | `.config/ghostty/config` |
| Karabiner-Elements | `.config/karabiner/karabiner.json` |
| VS Code / Cursor | `.vscode/settings.json` |

### Zsh plugins (sheldon)

| plugin | repo | load | status |
|---|---|---|---|
| `zsh-defer` | `romkatv/zsh-defer` | immediate | enabled |
| `zsh-autosuggestions` | `zsh-users/zsh-autosuggestions` | deferred | enabled |
| `zsh-syntax-highlighting` | `zsh-users/zsh-syntax-highlighting` | deferred | enabled |
| `zsh-autocomplete` | `marlonrichert/zsh-autocomplete` | n/a | disabled（コメントアウト） |

### Fish plugins (fisher)

| plugin | repo | note |
|---|---|---|
| `fisher` | `jorgebucaran/fisher` | plugin manager |
| `z` | `jethrokuan/z` | directory jumping |
| `fzf.fish` | `PatrickF1/fzf.fish` | fzf integration |

### mise tools（全件）

<details>
<summary>click to expand</summary>

<!-- generated from .config/mise/config.toml -->

#### CLI Tools - File Operations

| tool (mise key) | version | note |
|---|---:|---|
| `bat` | `latest` | cat with syntax highlighting |
| `eza` | `latest` | modern ls replacement |
| `fd` | `latest` | fast find alternative |
| `ripgrep` | `latest` | fast grep alternative |
| `yazi` | `latest` | terminal file manager |
| `zoxide` | `latest` | smart cd replacement |

#### CLI Tools - Text Processing

| tool (mise key) | version | note |
|---|---:|---|
| `jq` | `latest` | JSON processor |
| `sd` | `latest` | sed replacement |
| `choose` | `latest` | cut replacement |

#### CLI Tools - Git Tools

| tool (mise key) | version | note |
|---|---:|---|
| `github-cli` | `latest` | GitHub CLI |
| `hub` | `latest` | GitHub wrapper |
| `delta` | `latest` | git diff viewer |
| `difftastic` | `latest` | structural diff tool |
| `lazygit` | `latest` | Git TUI |
| `ghq` | `latest` | Git repository manager |

#### CLI Tools - System Monitoring

| tool (mise key) | version | note |
|---|---:|---|
| `gping` | `latest` | ping with graph |
| `bottom` | `latest` | htop replacement |
| `aqua:dalance/procs` | `latest` | ps replacement |
| `dust` | `latest` | du replacement |
| `tokei` | `latest` | code statistics |

#### CLI Tools - Search & Navigation

| tool (mise key) | version | note |
|---|---:|---|
| `fzf` | `latest` | fuzzy finder |
| `peco` | `latest` | interactive filtering |
| `aqua:cantino/mcfly` | `latest` | command history search |

#### CLI Tools - Documentation

| tool (mise key) | version | note |
|---|---:|---|
| `aqua:dbrgn/tealdeer` | `latest` | tldr Rust implementation (use 'tldr' command) |

#### CLI Tools - Development

| tool (mise key) | version | note |
|---|---:|---|
| `neovim` | `latest` | modern vim |
| `tmux` | `latest` | terminal multiplexer |
| `zellij` | `latest` | tmux alternative |
| `just` | `latest` | command runner |
| `watchexec` | `latest` | file watcher |
| `dotenvx` | `latest` | .env file runner |

#### CLI Tools - Cloud & Infrastructure

| tool (mise key) | version | note |
|---|---:|---|
| `aws` | `latest` | AWS CLI |
| `terraform` | `latest` | Infrastructure as Code |
| `act` | `latest` | GitHub Actions locally |
| `railway` | `latest` | Railway CLI |
| `supabase` | `latest` | Supabase CLI |
| `docker-cli` | `latest` | Docker CLI |

#### CLI Tools - Utilities

| tool (mise key) | version | note |
|---|---:|---|
| `coreutils` | `latest` | GNU core utilities |
| `cmake` | `latest` | build system |
| `ffmpeg` | `latest` | media processing |
| `resvg` | `latest` | SVG rendering |
| `spark` | `latest` | sparklines |

#### CLI Tools - Code Quality

| tool (mise key) | version | note |
|---|---:|---|
| `biome` | `latest` | formatter & linter |
| `buf` | `latest` | Protocol Buffers tool |

#### CLI Tools - Other

| tool (mise key) | version | note |
|---|---:|---|
| `1password` | `latest` | 1Password CLI |
| `chromedriver` | `latest` | ChromeDriver |
| `codex` | `latest` | Codex CLI |
| `hyperfine` | `latest` | benchmarking tool |
| `atuin` | `latest` | shell history manager |

#### Node.js

| tool (mise key) | version | note |
|---|---:|---|
| `node` | `latest` |  |
| `npm:serverless` | `v3` |  |
| `npm:aws-cdk` | `latest` |  |
| `npm:cdktf-cli` | `latest` |  |

#### Python

| tool (mise key) | version | note |
|---|---:|---|
| `python` | `latest` |  |
| `uv` | `latest` |  |
| `pipx:cfn-lint` | `latest` |  |
| `pipx:git-remote-codecommit` | `latest` |  |
| `pipx:snowflake-cli` | `latest` |  |

#### Ruby

| tool (mise key) | version | note |
|---|---:|---|
| `ruby` | `latest` |  |

#### Go

| tool (mise key) | version | note |
|---|---:|---|
| `go` | `latest` |  |

#### Java

| tool (mise key) | version | note |
|---|---:|---|
| `java` | `latest` |  |

#### Bun / Deno

| tool (mise key) | version | note |
|---|---:|---|
| `bun` | `latest` |  |
| `deno` | `latest` |  |

</details>

### Neovim plugins（lazy-lock: 全件）

<details>
<summary>click to expand</summary>

<!-- generated from .config/nvim/lazy-lock.json -->

| plugin | branch | commit |
|---|---|---|
| `blink.cmp` | `main` | `b19413d214068f316c78978b08264ed1c41830ec` |
| `bufferline.nvim` | `main` | `655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3` |
| `catppuccin` | `main` | `6efc53e42cfc97700f19043105bf73ba83c4ae7d` |
| `close-buffers.nvim` | `master` | `3acbcad1211572342632a6c0151f839e7dead27f` |
| `conform.nvim` | `master` | `8314f4c9e205e7f30b62147069729f9a1227d8bf` |
| `copilot.lua` | `master` | `e78d1ffebdf6ccb6fd8be4e6898030c1cf5f9b64` |
| `crates.nvim` | `main` | `ac9fa498a9edb96dc3056724ff69d5f40b898453` |
| `dial.nvim` | `master` | `f2634758455cfa52a8acea6f142dcd6271a1bf57` |
| `flash.nvim` | `main` | `fcea7ff883235d9024dc41e638f164a450c14ca2` |
| `friendly-snippets` | `main` | `572f5660cf05f8cd8834e096d7b4c921ba18e175` |
| `git.nvim` | `main` | `13f48998f0a6c245366f3aaf76947e56a932a57d` |
| `gitsigns.nvim` | `main` | `30e5c516f03e0a0a4f71300c52abad481ee90337` |
| `grug-far.nvim` | `main` | `794f03c97afc7f4b03fb6ec5111be507df1850cf` |
| `inc-rename.nvim` | `main` | `2597bccb57d1b570fbdbd4adf88b955f7ade715b` |
| `incline.nvim` | `main` | `8b54c59bcb23366645ae10edca6edfb9d3a0853e` |
| `lazy.nvim` | `main` | `85c7ff3711b730b4030d03144f6db6375044ae82` |
| `lazydev.nvim` | `main` | `5231c62aa83c2f8dc8e7ba957aa77098cda1257d` |
| `LazyVim` | `main` | `28db03f958d58dfff3c647ce28fdc1cb88ac158d` |
| `lualine.nvim` | `master` | `47f91c416daef12db467145e16bed5bbfe00add8` |
| `mason-lspconfig.nvim` | `main` | `4cfe411526a7a99c18281135e8b4765ae6330d15` |
| `mason.nvim` | `main` | `44d1e90e1f66e077268191e3ee9d2ac97cc18e65` |
| `mini.ai` | `main` | `bfb26d9072670c3aaefab0f53024b2f3729c8083` |
| `mini.bracketed` | `main` | `e50e3abcf6a3a5d234f58e4a247dfb3035f30a65` |
| `mini.hipatterns` | `main` | `add8d8abad602787377ec5d81f6b248605828e0f` |
| `mini.icons` | `main` | `efc85e42262cd0c9e1fdbf806c25cb0be6de115c` |
| `mini.pairs` | `main` | `d5a29b6254dad07757832db505ea5aeab9aad43a` |
| `neovim-ayu` | `master` | `38caa8b5b969010b1dcae8ab1a569d7669a643d5` |
| `noice.nvim` | `main` | `7bfd942445fb63089b59f97ca487d605e715f155` |
| `nui.nvim` | `main` | `de740991c12411b663994b2860f1a4fd0937c130` |
| `nvim-highlight-colors` | `main` | `e0c4a58ec8c3ca7c92d3ee4eb3bc1dd0f7be317e` |
| `nvim-lint` | `master` | `ca6ea12daf0a4d92dc24c5c9ae22a1f0418ade37` |
| `nvim-lspconfig` | `master` | `5a82e10b2df0ed31bec642c1c0344baee7c458b6` |
| `nvim-notify` | `master` | `8701bece920b38ea289b457f902e2ad184131a5d` |
| `nvim-treesitter` | `main` | `9177f2ff061627f0af0f994e3a3c620a84c0c59b` |
| `nvim-treesitter-textobjects` | `main` | `28a3494c075ef0f353314f627546537e43c09592` |
| `nvim-ts-autotag` | `main` | `c4ca798ab95b316a768d51eaaaee48f64a4a46bc` |
| `persistence.nvim` | `main` | `b20b2a7887bd39c1a356980b45e03250f3dce49c` |
| `plenary.nvim` | `master` | `b9fd5226c2f76c951fc8ed5923d85e4de065e509` |
| `rustaceanvim` | `master` | `4e9e40432b21df641f08c4ec058f2d6f89365526` |
| `SchemaStore.nvim` | `main` | `d5687736d15cfc3c1ac943485cad7808ba487d2b` |
| `snacks.nvim` | `main` | `fe7cfe9800a182274d0f868a74b7263b8c0c020b` |
| `solarized-osaka.nvim` | `main` | `f796014c14b1910e08d42cc2077fef34f08e0295` |
| `telescope-file-browser.nvim` | `master` | `3610dc7dc91f06aa98b11dca5cc30dfa98626b7e` |
| `telescope-fzf-native.nvim` | `main` | `6fea601bd2b694c6f2ae08a6c6fab14930c60e2c` |
| `telescope.nvim` | `master` | `3333a52ff548ba0a68af6d8da1e54f9cd96e9179` |
| `todo-comments.nvim` | `main` | `31e3c38ce9b29781e4422fc0322eb0a21f4e8668` |
| `tokyonight.nvim` | `main` | `5da1b76e64daf4c5d410f06bcb6b9cb640da7dfd` |
| `trouble.nvim` | `main` | `bd67efe408d4816e25e8491cc5ad4088e708a69a` |
| `ts-comments.nvim` | `main` | `123a9fb12e7229342f807ec9e6de478b1102b041` |
| `which-key.nvim` | `main` | `3aab2147e74890957785941f0c1ad87d0a44c15a` |
| `zen-mode.nvim` | `main` | `8564ce6d29ec7554eb9df578efa882d33b3c23a7` |

</details>

### VS Code / Cursor（settings から参照されている拡張）

> ここに載っているのは「`settings.json` が参照している extension id」です（拡張自体のインストールは行いません）。

| extension id | used in |
|---|---|
| `bmewburn.vscode-intelephense-client` | `[php]` |
| `esbenp.prettier-vscode` | `[css]`, `[javascript]`, `[javascriptreact]`, `[json]`, `[jsonc]`, `[scss]`, `[typescript]`, `[typescriptreact]`, `[vue]` |
| `foxundermoon.shell-format` | `[shellscript]` |
| `JohnnyMorganz.stylua` | `[lua]` |
| `ms-python.python` | `[python]` |
| `redhat.vscode-yaml` | `[yaml]` |
| `tamasfe.even-better-toml` | `[toml]` |
| `vscode.html-language-features` | `[html]` |

### CI

| area | tool | config |
|---|---|---|
| Lua formatting | [StyLua](https://github.com/JohnnyMorganz/StyLua) | `stylua.toml` |
| GitHub Actions | [stylua-action](https://github.com/JohnnyMorganz/stylua-action) | `.github/workflows/stylua.yml` |
