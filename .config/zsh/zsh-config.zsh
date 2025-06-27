#---------------------------
# Zsh Core Configuration
#---------------------------

#---------------------------
# History Settings
#---------------------------
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

# Create history directory if it doesn't exist
[[ ! -d "${HISTFILE:h}" ]] && mkdir -p "${HISTFILE:h}"

# History options
setopt hist_ignore_dups         # 直前と同じコマンドは履歴に追加しない
setopt hist_ignore_all_dups     # 重複するコマンドは古い方を削除
setopt hist_ignore_space        # スペースで始まるコマンドは履歴に追加しない
setopt hist_reduce_blanks       # 余分なスペースを削除
setopt hist_save_no_dups        # 重複するコマンドは保存しない
setopt share_history            # 履歴を共有
setopt extended_history         # 履歴にタイムスタンプを記録

#---------------------------
# Basic Zsh Options
#---------------------------
setopt no_beep                  # ビープ音を鳴らさない
setopt correct                  # コマンドのスペルを訂正
setopt list_packed              # 補完候補を詰めて表示
setopt auto_cd                  # ディレクトリ名のみでcd
setopt auto_pushd               # cd時に自動でpushdする
setopt pushd_ignore_dups        # 重複するディレクトリはpushdしない
setopt extended_glob            # 拡張グロブを有効にする
setopt numeric_glob_sort        # 数値順でソート

#---------------------------
# Completion Settings
#---------------------------
# Initialize completion system
autoload -Uz compinit

# Use cache for faster completion loading
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Add homebrew completions if exists
if [[ -d /opt/homebrew/share/zsh-completions ]]; then
  fpath=(/opt/homebrew/share/zsh-completions $fpath)
fi

# Completion styles
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'           # 大文字小文字を区別しない
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}        # 補完候補に色を付ける
zstyle ':completion:*' menu select                           # 補完候補をメニューで選択
zstyle ':completion:*' group-name ''                         # グループ名を表示しない
zstyle ':completion:*' verbose yes                           # 詳細な補完情報を表示
zstyle ':completion:*:descriptions' format '%B%d%b'          # 説明のフォーマット
zstyle ':completion:*:messages' format '%d'                  # メッセージのフォーマット
zstyle ':completion:*:warnings' format 'No matches for: %d'  # 警告のフォーマット
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b' # 訂正のフォーマット

# Kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"