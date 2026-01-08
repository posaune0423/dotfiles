function update_completions --description "Update fish completions (generated + tool-provided)"
    # Store locally under fish config, but keep it untracked via .gitignore.
    set -l outdir "$__fish_config_dir/completions.local"
    command mkdir -p "$outdir"

    # 1) Generate basic completions from man pages (best-effort).
    if type -q fish_update_completions
        fish_update_completions >/dev/null 2>&1
    end

    # 2) Prefer tool-provided fish completions when available.
    if type -q bun
        bun completions fish >"$outdir/bun.fish"
    end

    if type -q rustup
        rustup completions fish >"$outdir/rustup.fish"
    end

    if type -q mise
        mise completions fish >"$outdir/mise.fish"
    end

    echo "Updated completions in: $outdir"
end

