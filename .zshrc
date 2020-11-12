# env
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

# setting for history
HISTFILE=~/.zsh_history
HISTSIZE=30000
SAVEHIST=30000
# ignore duplicated commands
setopt hist_ignore_dups
# not Leaving same command in history
setopt hist_ignore_all_dups
# share history between multiple shells
setopt share_history

# activate completion
autoload -Uz compinit
compinit -u
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi
# completion matches capital and small letters
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# show suggested list packed
setopt list_packed
# make suggested list colored
zstyle ':completion:*' list-colors ''

# activate plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# correct misspel
setopt correct
# cancel beep sound
setopt no_beep

# prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd() { vcs_info }
PROMPT='%T %~ %F{magenta}$%f '
RPROMPT='${vcs_info_msg_0_}'

# alias
alias ls='ls -aF'
alias ll='ls -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'
alias cat='cat -n'
alias less='less -NM'
alias g='git'
