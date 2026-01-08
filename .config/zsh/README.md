# Modular Zsh Configuration

Nix-first のモジュラー Zsh 設定です。

## ファイル構成

```
~/.zshenv          # PATH設定（Nix優先）
~/.zprofile        # ログインシェル・GUI環境変数
~/.zshrc           # モジュール読み込み
~/.config/zsh/
├── core.zsh       # 履歴・オプション
├── completion.zsh # 補完（Nix site-functions）
├── aliases.zsh    # エイリアス
├── functions.zsh  # カスタム関数
├── tools.zsh      # zoxide, atuin, mcfly 初期化
└── prompt.zsh     # Starship
```

## カスタマイズ

### 新しいツールを追加
`nix/darwin/default.nix` → `environment.systemPackages` に追加後、`nix run .#switch`

### 新しいエイリアス
`aliases.zsh` に追記

### 新しい関数
`functions.zsh` に追記
