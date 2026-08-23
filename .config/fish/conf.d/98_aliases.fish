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

function gho
    gh pr view --web 2>/dev/null; or gh browse
end

# git-wt: pick a worktree with fzf and jump to it (`git wt` handles create/delete)
function wt --description 'Select a git worktree with fzf and cd into it'
    if not type -q git-wt; or not type -q fzf
        echo "wt: git-wt and fzf are required" >&2
        return 1
    end
    if not command git rev-parse --git-dir >/dev/null 2>&1
        echo "wt: not inside a git repository" >&2
        return 1
    end
    set -l target (command git-wt | fzf --header-lines=1 --prompt 'worktree> ' \
        | awk '{if ($1 == "*") print $2; else print $1}')
    if test -z "$target"
        return 1
    end
    cd $target
end

#---------------------------
# Cursor Terminal: Disable q command
#---------------------------
if test "$TERM_PROGRAM" = vscode; or set -q CURSOR_TRACE_ID
    alias q 'echo "q command disabled in Cursor terminal"'
end
