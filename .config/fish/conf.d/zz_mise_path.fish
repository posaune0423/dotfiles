#---------------------------
# mise first
#---------------------------
# Tool installers prepend their own bin directories from conf.d (Vite+ puts
# node / npm / pnpm in ~/.vite-plus/bin; rustup, Solana and others add theirs).
# This file sorts after them, so mise shims go back to the front and every
# mise-managed tool resolves from mise. Commands only those directories
# provide, such as `vp`, stay reachable behind it.
#---------------------------
set -l mise_data_dir (set -q MISE_DATA_DIR; and echo $MISE_DATA_DIR; or echo $HOME/.local/share/mise)
if test -d $mise_data_dir/shims
    fish_add_path --path --move --prepend $mise_data_dir/shims
end
