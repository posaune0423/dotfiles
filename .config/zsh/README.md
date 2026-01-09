# Zsh

Zsh の設定はモジュール化して `~/.config/zsh/` に分割しています。読み込み順は `.zshrc` に定義されています。

## Load order

1. `.zshenv`（全 zsh 起動で読み込み）
2. `.zprofile`（login shell のみ）
3. `.zshrc`（interactive: `.config/zsh/*.zsh` を順に読み込み → sheldon で plugin 読み込み）

`.zshrc` が読み込むモジュール:

| module | file | role |
|---|---|---|
| `core` | `core.zsh` | 基本設定（history / options） |
| `completion` | `completion.zsh` | 補完 |
| `aliases` | `aliases.zsh` | alias |
| `functions` | `functions.zsh` | 関数 |
| `tools` | `tools.zsh` | ツール初期化 |
| `prompt` | `prompt.zsh` | prompt（starship） |

## Plugins

Zsh のプラグインは [sheldon](https://github.com/rossmacarthur/sheldon) で管理し、定義は `~/.config/sheldon/plugins.toml` にあります。