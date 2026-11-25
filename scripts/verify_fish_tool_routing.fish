#!/usr/bin/env fish
# Fish startup must resolve mise-managed tools from mise, ahead of every other
# bin directory the conf.d files or tool installers put on PATH (~/.local/bin,
# ~/.cargo/bin, ~/.vite-plus/bin, ...), and must do so without writing the
# universal fish_user_paths.
#
# The conf.d files run in a separate fish with a temporary HOME and config
# directory, so this check never touches the real universal variables.

set repo_root (path resolve (dirname (status filename))/..)
set temp_base (set -q TMPDIR; and echo $TMPDIR; or echo /tmp)
set test_home (path normalize (mktemp -d "$temp_base/fish-tool-routing.XXXXXX"))
function __verify_fish_tool_routing_cleanup --on-event fish_exit
    rm -rf $test_home
end

set mise_shims $test_home/.local/share/mise/shims
set vite_bin $test_home/.vite-plus/bin
mkdir -p $mise_shims $test_home/.local/bin $test_home/.cargo/bin $vite_bin \
    $test_home/Library/pnpm $test_home/.config/fish

function __fake --argument-names path output
    printf '%s\n' '#!/bin/sh' "echo $output" >$path
    chmod +x $path
end
for tool in uv codex node
    __fake $mise_shims/$tool "mise-$tool"
end
__fake $test_home/.local/bin/codex desktop-codex
__fake $test_home/.cargo/bin/uv cargo-uv
__fake $vite_bin/node vite-node
__fake $vite_bin/vp vite-vp
# Same shape as the env.fish the Vite+ installer writes.
printf '%s\n' 'set -gx PATH $HOME/.vite-plus/bin $PATH' >$test_home/.vite-plus/env.fish

# Sources conf.d in Fish's lexical order, skipping machine-local files, then
# prints one "name=value" line per observation.
set inner '
    set -gx PATH $HOME/Library/pnpm /usr/bin /bin
    for f in (path sort $argv[1]/*.fish)
        string match -q -r "(\\.local\\.fish|/99_local_secrets\\.fish)\$" -- $f; and continue
        source $f
    end
    for tool in uv codex node vp
        echo "$tool="(command -s $tool)
    end
    functions -q codex; and echo "codex_function=yes"
    contains -- $HOME/Library/pnpm $PATH; and echo "legacy_pnpm=yes"
    echo "gopath=$GOPATH"
'
# Prompt and plugin files complain without their functions; keep that noise in
# a log and show it only when a check fails.
set inner_log $test_home/inner.log
set observed (env -u MISE_DATA_DIR -u fish_user_paths HOME=$test_home \
    XDG_CONFIG_HOME=$test_home/.config XDG_DATA_HOME=$test_home/.local/share \
    fish --no-config -c $inner $repo_root/.config/fish/conf.d 2>$inner_log)

set failures 0
function __expect --argument-names name expected
    set -l line (string match -- "$name=*" $observed)
    set -l actual (string replace -- "$name=" "" $line)
    if test "$actual" != "$expected"
        echo "[fail] $name: expected '$expected', got '$actual'" >&2
        set failures (math $failures + 1)
    end
end

__expect uv $mise_shims/uv # ahead of ~/.cargo/bin
__expect codex $mise_shims/codex # ahead of a Desktop CLI in ~/.local/bin
__expect node $mise_shims/node # ahead of ~/.vite-plus/bin
__expect vp $vite_bin/vp # tools only Vite+ provides stay reachable
__expect codex_function ""
__expect legacy_pnpm ""
__expect gopath $test_home/go

if test -f $test_home/.config/fish/fish_variables
    and string match -q '*fish_user_paths*' <$test_home/.config/fish/fish_variables
    echo "[fail] Fish startup wrote the universal fish_user_paths" >&2
    set failures (math $failures + 1)
end

if test $failures -ne 0
    echo "--- conf.d stderr:" >&2
    string match -v -r '_pure_set_default|__z_complete|^\s*\^|from sourcing file|^/.*\(line [0-9]+\): $|^_pure|^\s*$' <$inner_log >&2
    exit 1
end
echo "[ok] Fish resolves mise tools first and leaves fish_user_paths alone"
