# Fish

Fish の設定は `~/.config/fish/` に集約しています（XDG 準拠）。

## Load order

- `conf.d/*.fish`（ファイル名順で自動読み込み）
- `config.fish`（主に interactive 用の入口）
- `functions/*.fish`（呼ばれた時に遅延ロード）

## Layout

```
.config/fish/
├── config.fish
├── conf.d/
│   ├── 00_fig_pre.fish
│   ├── 00_kiro_pre.fish
│   ├── 01_env.fish
│   ├── 02_path.fish
│   ├── 03_tools.fish
│   ├── 04_completions_path.fish
│   ├── 98_aliases.fish
│   ├── 99_fig_post.fish
│   ├── 99_kiro_post.fish
│   └── z.fish
├── fish_plugins
├── functions/
│   ├── cat.fish
│   ├── update_completions.fish
│   └── __z*.fish
└── completions/
    ├── bun.fish
    └── fisher.fish
```

## Plugins (fisher)

プラグインは [fisher](https://github.com/jorgebucaran/fisher) で管理し、一覧は `fish_plugins` に置いています。

| plugin | repo |
|---|---|
| `fisher` | `jorgebucaran/fisher` |
| `z` | `jethrokuan/z` |
| `fzf.fish` | `PatrickF1/fzf.fish` |
