#---------------------------
# Development Tools Library Loading
#---------------------------

# z (directory jumping)
[[ -f /opt/homebrew/etc/profile.d/z.sh ]] && . /opt/homebrew/etc/profile.d/z.sh

# Reuse the authenticated GitHub CLI token for tools that query GitHub APIs.
if [[ -z "${GITHUB_TOKEN:-}" ]] && command -v gh &> /dev/null; then
  _gh_token="$(gh auth token 2> /dev/null)" || _gh_token=""
  [[ -n "$_gh_token" ]] && export GITHUB_TOKEN="$_gh_token"
  unset _gh_token
fi

# fzf (fuzzy finder) - key bindings and completion
if command -v fzf &> /dev/null; then
  source <(fzf --zsh)
fi

# Note: Version management (Node/Python/Ruby/Go/Java/Bun/Deno) is now handled by mise.
# PATH (brew, mise shims, pnpm, bun, lm-studio, etc.) is built in ~/.config/zsh/path-exports.zsh
# and sourced from ~/.zshenv.

# git-wt (git worktree helper)
# Enables `git wt <branch>` to create/switch worktrees and cd into them, plus
# completion. The hook installs a `git` wrapper function that only intercepts
# `git wt` and delegates every other subcommand to the real binary.
if command -v git-wt &> /dev/null; then
  eval "$(git wt --init zsh)"
fi
