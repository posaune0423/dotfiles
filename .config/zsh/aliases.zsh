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

# GitHub: open PR page if exists, otherwise repo page
gho() {
  gh pr view --web 2> /dev/null || gh browse
}

# git-wt: pick a worktree with fzf and jump to it (`git wt` handles create/delete)
wt() {
  if ! command -v git-wt &> /dev/null || ! command -v fzf &> /dev/null; then
    echo "wt: git-wt and fzf are required" >&2
    return 1
  fi
  if ! command git rev-parse --git-dir &> /dev/null; then
    echo "wt: not inside a git repository" >&2
    return 1
  fi
  local target
  target="$(command git-wt | fzf --header-lines=1 --prompt='worktree> ' |
    awk '{if ($1 == "*") print $2; else print $1}')"
  [[ -n "$target" ]] && cd "$target"
}

# Cursor内でのみqコマンドを無効化
if [[ "$TERM_PROGRAM" == "vscode" ]] || [[ -n "$CURSOR_TRACE_ID" ]]; then
  alias q='echo "q command disabled in Cursor terminal"'
fi
