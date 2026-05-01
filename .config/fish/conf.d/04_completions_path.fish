# Keep auto-generated completions out of the dotfiles repo.
# Fish looks for completion scripts in $fish_complete_path.
# Ref: https://fishshell.com/docs/current/completions.html

if status is-interactive
    # Local completions dir (untracked, see .gitignore)
    set -l __local_completions_dir "$__fish_config_dir/completions.local"
    set -l __repo_completions_dir "$__fish_config_dir/completions"

    if not test -d "$__local_completions_dir"
        command mkdir -p "$__local_completions_dir" 2>/dev/null
    end

    # Prepend so local/generated completions override tracked repo completions.
    set -gx fish_complete_path "$__local_completions_dir" "$__repo_completions_dir" $fish_complete_path
end
