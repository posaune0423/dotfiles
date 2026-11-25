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
printf '%s\n' '#!/bin/sh' 'echo codex-cli mise-test' >$mise_shims/codex
printf '%s\n' '#!/bin/sh' 'echo codex-cli desktop-test' >$desktop_codex
chmod +x $mise_shims/uv $mise_shims/codex $desktop_codex

set -gx PATH $HOME/Library/pnpm /usr/bin /bin
source $repo_root/.config/fish/conf.d/01_env.fish
source $repo_root/.config/fish/conf.d/02_path.fish

set actual_uv (command -s uv)
if test "$actual_uv" != "$mise_shims/uv"
    echo "[fail] expected mise uv at $mise_shims/uv, got $actual_uv" >&2
    exit 1
end

# Codex is a mise-managed npm tool; a Desktop-bundled CLI in ~/.local/bin
# must not shadow it.
set actual_codex (command -s codex)
if test "$actual_codex" != "$mise_shims/codex"
    echo "[fail] expected mise codex at $mise_shims/codex, got $actual_codex" >&2
    exit 1
end
if functions -q codex
    echo "[fail] a codex function overrides the mise-managed CLI" >&2
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

echo "[ok] Fish keeps mise tools, including Codex, ahead of ~/.local/bin"
