#---------------------------
# History Settings
#---------------------------
HISTFILE=~/.zsh_history
HISTSIZE=30000
SAVEHIST=30000

#---------------------------
# Basic Options
#---------------------------
setopt hist_ignore_dups     # 直前と同じコマンドは履歴に追加しない
setopt hist_ignore_all_dups # 重複するコマンドは古い方を削除
setopt share_history        # 履歴を共有
setopt no_beep              # ビープ音を鳴らさない
setopt correct              # コマンドのスペルを訂正
setopt list_packed          # 補完候補を詰めて表示

#---------------------------
# Homebrew Settings
#---------------------------
HOMEBREW_CASK_OPTS="--appdir=/Applications"

#---------------------------
# Completion Settings
#---------------------------
autoload -Uz compinit
compinit -u

# Add homebrew completions if exists
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 大文字小文字を区別しない
zstyle ':completion:*' list-colors ''               # 補完候補に色を付ける

#---------------------------
# Plugins
#---------------------------
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#---------------------------
# Prompt Settings
#---------------------------
autoload -Uz vcs_info
setopt prompt_subst

# Git status configuration
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

# Prompt format
PROMPT='%T %n %~ %F{magenta}$%f '
RPROMPT='${vcs_info_msg_0_}'

#---------------------------
# Aliases
#---------------------------
# File operations
alias ls='eza -g --icons'
alias ll='eza -g -l --icons'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Editor
alias vi='nvim'
alias vim='nvim'

# Others
alias less='less -NM'
alias reload='source ~/.zshrc'
alias restart='exec $SHELL -l'
alias g='git'

#---------------------------
# Custom Functions
#---------------------------
# Enhanced cat function with image support
function cat() {
  for file in "$@"; do
    case "${file##*.}" in
    jpg | jpeg | png | gif | bmp | tiff | webp)
      wezterm imgcat "$file"
      ;;
    *)
      bat "$file"
      ;;
    esac
  done
}

#-------------------------
# Libraries
# ------------------------
. /opt/homebrew/etc/profile.d/z.sh
