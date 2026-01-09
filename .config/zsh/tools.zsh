#---------------------------
# Development Tools Library Loading
#---------------------------

# z (directory jumping)
[[ -f /opt/homebrew/etc/profile.d/z.sh ]] && . /opt/homebrew/etc/profile.d/z.sh

# fzf (fuzzy finder) - key bindings and completion
if command -v fzf &> /dev/null; then
  source <(fzf --zsh)
fi

# Note: Version management (Node/Python/Ruby/Go/Java/Bun/Deno) is now handled by mise
# See ~/.zshrc for mise activation
