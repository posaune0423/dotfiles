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

    # Disable Primary Device Attribute query to suppress terminal compatibility warnings
    # Some terminals don't respond to this query, causing warnings on startup
    set -g fish_use_primary_device_attribute 0

    # Enable vi mode (optional, uncomment if you prefer vi keybindings)
    # fish_vi_key_bindings

    #---------------------------
    # Syntax Highlighting Colors
    #---------------------------
    # Fish has built-in syntax highlighting, configure colors here
    set -g fish_color_command green # Valid commands
    set -g fish_color_error red # Invalid commands
    set -g fish_color_param cyan # Command parameters
    set -g fish_color_quote yellow # Quoted strings
    set -g fish_color_redirection magenta # Redirections (>, <, |)
    set -g fish_color_end green # End of command (;, &)
    set -g fish_color_comment brblack # Comments
    set -g fish_color_autosuggestion brblack # Autosuggestions
    set -g fish_color_operator cyan # Operators ($, *, etc.)
    set -g fish_color_escape cyan # Escape sequences (\n, etc.)
    set -g fish_color_valid_path --underline # Valid file paths
end
