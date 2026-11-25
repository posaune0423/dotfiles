#---------------------------
# PATH Configuration
#---------------------------
# fish_add_path --path edits $PATH for this session only. Without it, fish_add_path
# saves into the universal fish_user_paths, which outlives this file: stale or
# temporary directories pile up there and decide the PATH order.
#---------------------------

# Helper function to add paths only if directory exists
function __add_path_if_exists
    for dir in $argv
        if test -d $dir
            fish_add_path --path --move --prepend $dir
        end
    end
end

function __append_path_if_exists
    for dir in $argv
        if test -d $dir
            fish_add_path --path --append $dir
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
