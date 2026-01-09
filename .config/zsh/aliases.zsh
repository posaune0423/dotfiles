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
alias sleepon='sudo pmset -a disablesleep 0'
alias sleepoff='sudo pmset -a disablesleep 1'

# Development tools
alias g='git'
alias pn='pnpm'
alias pip=pip3

# Node.js
alias nodets="node --experimental-strip-types --experimental-transform-types --experimental-detect-module --no-warnings=ExperimentalWarning"

# Cursor内でのみqコマンドを無効化
if [[ "$TERM_PROGRAM" == "vscode" ]] || [[ -n "$CURSOR_TRACE_ID" ]]; then
  alias q='echo "q command disabled in Cursor terminal"'
fi
