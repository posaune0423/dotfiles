#---------------------------
# PATH Configuration
#---------------------------
# Fish handles PATH deduplication automatically via fish_add_path
#---------------------------

# Helper function to add paths only if directory exists
function __add_path_if_exists
    for dir in $argv
        if test -d $dir
            fish_add_path --prepend $dir
        end
    end
end

function __append_path_if_exists
    for dir in $argv
        if test -d $dir
            fish_add_path --append $dir
        end
    end
end

#---------------------------
# Homebrew (High Priority)
#---------------------------
__add_path_if_exists /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin

#---------------------------
# User Binaries
#---------------------------
__add_path_if_exists $HOME/bin $HOME/.local/bin

#---------------------------
# mise (Version Manager) Shims
#---------------------------
set -l mise_data_dir (set -q MISE_DATA_DIR; and echo $MISE_DATA_DIR; or echo $HOME/.local/share/mise)
__add_path_if_exists $mise_data_dir/shims $mise_data_dir/bin

#---------------------------
# Language Runtime Paths
#---------------------------
# Go binaries
__append_path_if_exists $GOPATH/bin

# pnpm
__append_path_if_exists $PNPM_HOME

# Bun global binaries
__append_path_if_exists $HOME/.cache/.bun/bin

# LM Studio CLI
__append_path_if_exists $HOME/.cache/lm-studio/bin

# Solana
__add_path_if_exists $HOME/.local/share/solana/install/active_release/bin

#---------------------------
# Cleanup Helper Functions
#---------------------------
functions -e __add_path_if_exists
functions -e __append_path_if_exists
