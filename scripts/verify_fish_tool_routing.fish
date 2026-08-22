#!/usr/bin/env fish

set repo_root (path resolve (dirname (status filename))/..)
set temp_base (set -q TMPDIR; and echo $TMPDIR; or echo /tmp)
set test_home (mktemp -d "$temp_base/fish-tool-routing.XXXXXX")
function __verify_fish_tool_routing_cleanup --on-event fish_exit
    rm -rf $test_home
end
set -gx HOME $test_home
set mise_shims $HOME/.local/share/mise/shims
set desktop_codex $HOME/.local/bin/codex

mkdir -p $mise_shims $HOME/.local/bin $HOME/Library/pnpm
printf '%s\n' '#!/bin/sh' 'echo mise-uv' >$mise_shims/uv
printf '%s\n' '#!/bin/sh' 'echo codex-cli desktop-test' >$desktop_codex
chmod +x $mise_shims/uv $desktop_codex

set -gx PATH $HOME/Library/pnpm /usr/bin /bin
source $repo_root/.config/fish/conf.d/01_env.fish
source $repo_root/.config/fish/conf.d/02_path.fish
source $repo_root/.config/fish/conf.d/zz_codex-desktop.fish

set actual_uv (command -s uv)
if test "$actual_uv" != "$mise_shims/uv"
    echo "[fail] expected mise uv at $mise_shims/uv, got $actual_uv" >&2
    exit 1
end

set expected_codex_version 'codex-cli desktop-test'
set actual_codex_version (codex --version)
if test "$actual_codex_version" != "$expected_codex_version"
    echo "[fail] Codex does not resolve to the Desktop build" >&2
    exit 1
end

if set -q PNPM_HOME; or contains -- "$HOME/Library/pnpm" $PATH
    echo "[fail] legacy pnpm path remains after Fish startup" >&2
    exit 1
end
if test "$GOPATH" != "$HOME/go"
    echo "[fail] Fish startup did not initialize GOPATH" >&2
    exit 1
end

echo "[ok] Fish routes only Codex to Desktop and keeps mise tools first"
