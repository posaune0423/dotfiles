# setting for history
HISTFILE=~/.zsh_history
HISTSIZE=30000
SAVEHIST=30000

setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt share_history
setopt no_beep
setopt correct
setopt list_packed


# enable autocompletion
autoload -Uz compinit
compinit -u
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors ''

# enable plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd() { vcs_info }
PROMPT='%T %n %~ %F{magenta}$%f '
RPROMPT='${vcs_info_msg_0_}'

# alias
alias ls='ls -aF'
alias ll='ls -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='nvim'
alias vim='nvim'
alias cat='cat -n'
alias less='less -NM'
alias reload='source ~/.zshrc'
alias restart='exec $SHELL -l'
alias g='git'
alias ide='~/.scripts/ide.sh'

# for pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


# for preventing from warning when brew doctor
alias brew='PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin brew' 
HOMEBREW_CASK_OPTS="--appdir=/Applications"
