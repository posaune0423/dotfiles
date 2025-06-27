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
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

#---------------------------
# Specialized Tools Initialization
#---------------------------

# starkli (Starknet CLI)
[[ -f "$HOME/.starkli/env" ]] && . "$HOME/.starkli/env"

# deno (JavaScript/TypeScript runtime)
[[ -f "$HOME/.deno/env" ]] && . "$HOME/.deno/env"