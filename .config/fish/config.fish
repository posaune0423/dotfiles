#---------------------------
# Fish Shell Configuration
#---------------------------
# Main entry point for fish shell
#
# Configuration Loading Order:
#   1. conf.d/*.fish (auto-loaded in alphabetical order)
#      - 00_kiro_pre.fish  : Kiro CLI pre-hook
#      - 01_env.fish       : Environment variables
#      - 02_path.fish      : PATH configuration
#      - 03_tools.fish     : Tool initialization (mise, cargo, etc.)
#      - 98_aliases.fish   : Shell aliases
#      - 99_kiro_post.fish : Kiro CLI post-hook
#      - z.fish            : z directory jumping (fisher plugin)
#   2. functions/*.fish (auto-loaded on demand)
#   3. This file (config.fish) - for interactive shell settings
#
# Plugin Management: fisher (fish_plugins file)
#---------------------------

if status is-interactive
    #---------------------------
    # Starship Prompt
    #---------------------------
    if type -q starship
        starship init fish | source
    end

    #---------------------------
    # Fish-specific Settings
    #---------------------------
    # Disable greeting message
    set -g fish_greeting

    # Enable vi mode (optional, uncomment if you prefer vi keybindings)
    # fish_vi_key_bindings
end
