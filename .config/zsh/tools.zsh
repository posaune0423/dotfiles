#---------------------------
# Development Tools Runtime Initialization
#---------------------------

# pyenv (Python version manager) - runtime initialization
# if command -v pyenv >/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi

# rbenv (Ruby version manager) - runtime initialization
# if command -v rbenv >/dev/null 2>&1; then
#   eval "$(rbenv init -)"
# fi

#---------------------------
# Development Tools Library Loading
#---------------------------

# z (directory jumping)
[[ -f /opt/homebrew/etc/profile.d/z.sh ]] && . /opt/homebrew/etc/profile.d/z.sh

# asdf (version manager)
[[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]] && . /opt/homebrew/opt/asdf/libexec/asdf.sh

# nvm (node version manager)
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"

# bun completions
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

#---------------------------
# Specialized Tools Initialization
#---------------------------

# starkli (Starknet CLI)
[[ -f "$HOME/.starkli/env" ]] && . "$HOME/.starkli/env"

# deno (JavaScript/TypeScript runtime) - already in PATH via .zshenv
# [[ -f "$DENO_INSTALL/env" ]] && . "$DENO_INSTALL/env"