#---------------------------
# Development Tools Initialization
#---------------------------

# zoxide (smarter cd replacement, installed via Nix)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# atuin (shell history manager, installed via Nix)
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# mcfly (history search, installed via Nix)
if command -v mcfly &>/dev/null; then
  eval "$(mcfly init zsh)"
fi
