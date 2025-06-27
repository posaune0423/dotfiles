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

# Terminal utilities
alias less='less -NM'
alias reload='source ~/.zshrc'
alias restart='exec $SHELL -l'

# Development tools
alias g='git'
alias pn='pnpm'
alias pip=pip3

# Node.js
alias nodets="node --experimental-strip-types --experimental-transform-types --experimental-detect-module --no-warnings=ExperimentalWarning"