#---------------------------
# Aliases
#---------------------------
# All shell aliases consolidated here
#---------------------------

#---------------------------
# File Operations
#---------------------------
alias ls 'eza -g --icons'
alias ll 'eza -g -l --icons'
alias lla 'eza -g -la --icons'
alias rm 'rm -i'
alias cp 'cp -i'
alias mv 'mv -i'

#---------------------------
# Editor
#---------------------------
alias vi nvim
alias vim nvim

#---------------------------
# Terminal Utilities
#---------------------------
alias less 'less -NM'
alias reload 'source ~/.config/fish/config.fish'
alias restart 'exec fish -l'
alias sleepon 'sudo pmset -a disablesleep 0'
alias sleepoff 'sudo pmset -a disablesleep 1'

#---------------------------
# Development Tools
#---------------------------
alias g git
alias pn pnpm
alias pip pip3

#---------------------------
# Node.js
#---------------------------
alias nodets 'node --experimental-strip-types --experimental-transform-types --experimental-detect-module --no-warnings=ExperimentalWarning'

#---------------------------
# Cursor Terminal: Disable q command
#---------------------------
if test "$TERM_PROGRAM" = vscode; or set -q CURSOR_TRACE_ID
    alias q 'echo "q command disabled in Cursor terminal"'
end
