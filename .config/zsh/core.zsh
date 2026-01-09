#---------------------------
# Core Zsh Configuration
#---------------------------
# Basic options, history, and behavior settings
# No completion or plugin settings here.
#---------------------------

#---------------------------
# Terminal Compatibility
#---------------------------
# Fix cursor position issues in some terminals (Ghostty, WezTerm)
# where prompt width calculation is off by 1 char.
export ZLE_RPROMPT_INDENT=0

#---------------------------
# History Settings
#---------------------------
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

# Create history directory if it doesn't exist
[[ ! -d "${HISTFILE:h}" ]] && mkdir -p "${HISTFILE:h}"

# History options
setopt hist_ignore_dups     # 直前と同じコマンドは履歴に追加しない
setopt hist_ignore_all_dups # 重複するコマンドは古い方を削除
setopt hist_ignore_space    # スペースで始まるコマンドは履歴に追加しない
setopt hist_reduce_blanks   # 余分なスペースを削除
setopt hist_save_no_dups    # 重複するコマンドは保存しない
setopt share_history        # 履歴を共有
setopt extended_history     # 履歴にタイムスタンプを記録

#---------------------------
# Basic Zsh Options
#---------------------------
setopt no_beep           # ビープ音を鳴らさない
setopt correct           # コマンドのスペルを訂正
setopt list_packed       # 補完候補を詰めて表示
setopt auto_cd           # ディレクトリ名のみでcd
setopt auto_pushd        # cd時に自動でpushdする
setopt pushd_ignore_dups # 重複するディレクトリはpushdしない
setopt extended_glob     # 拡張グロブを有効にする
setopt numeric_glob_sort # 数値順でソート
