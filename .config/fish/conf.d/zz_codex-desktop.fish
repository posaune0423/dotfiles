# Keep only the Codex CLI on the same build as Codex Desktop without moving
# every ~/.local/bin executable ahead of mise-managed tools.
if test -x $HOME/.local/bin/codex
    function codex --description 'Run the Codex Desktop bundled CLI'
        command $HOME/.local/bin/codex $argv
    end
end

# pnpm global tools are managed by mise; do not retain the retired global path.
set -gx PATH (string match -v "$HOME/Library/pnpm" -- $PATH)
