#---------------------------
# Tool Initialization
#---------------------------
# Initialize development tools and environments
#---------------------------

#---------------------------
# Cargo (Rust)
#---------------------------
if test -f $HOME/.cargo/env.fish
    source $HOME/.cargo/env.fish
else if test -d $HOME/.cargo/bin
    fish_add_path --prepend $HOME/.cargo/bin
end

#---------------------------
# Starkli
#---------------------------
if test -f $HOME/.starkli/env
    # Starkli doesn't have fish-specific env, just add to PATH
    fish_add_path --prepend $HOME/.starkli/bin
end

#---------------------------
# Local env scripts
#---------------------------
if test -f $HOME/.local/bin/env.fish
    source $HOME/.local/bin/env.fish
end

#---------------------------
# mise (Version Manager) - Interactive Shell Activation
#---------------------------
# mise shims are already on PATH from 02_path.fish
# This enables auto-switching for interactive shells
if status is-interactive
    if type -q mise
        mise activate fish | source
    end
end

#---------------------------
# direnv - Interactive Shell Hook
#---------------------------
# Automatically load/unload .envrc when moving between directories
if status is-interactive
    if type -q direnv
        direnv hook fish | source
    end
end

#---------------------------
# fzf (Fuzzy Finder)
#---------------------------
if status is-interactive
    if type -q fzf
        fzf --fish | source
    end
end
