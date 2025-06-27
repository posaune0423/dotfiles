#---------------------------
# Zsh Core Configuration
#---------------------------

#---------------------------
# History Settings
#---------------------------
HISTFILE=~/.zsh_history
HISTSIZE=30000
SAVEHIST=30000

# History options
setopt hist_ignore_dups     # 直前と同じコマンドは履歴に追加しない
setopt hist_ignore_all_dups # 重複するコマンドは古い方を削除
setopt share_history        # 履歴を共有

#---------------------------
# Basic Zsh Options
#---------------------------
setopt no_beep              # ビープ音を鳴らさない
setopt correct              # コマンドのスペルを訂正
setopt list_packed          # 補完候補を詰めて表示
setopt auto_cd              # ディレクトリ名のみでcd

#---------------------------
# Completion Settings
#---------------------------
autoload -Uz compinit
compinit -u

# Add homebrew completions if exists
if [[ -e /usr/local/share/zsh-completions ]]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

# Completion styles
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 大文字小文字を区別しない
zstyle ':completion:*' list-colors ''               # 補完候補に色を付ける