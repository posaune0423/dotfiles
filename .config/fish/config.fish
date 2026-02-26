#---------------------------
# Fish Shell Configuration
#---------------------------
# Main entry point for fish shell
#
# Configuration Loading Order:
#   1. conf.d/*.fish (auto-loaded in alphabetical order)
#      - 01_env.fish       : Environment variables
#      - 02_path.fish      : PATH configuration
#      - 03_tools.fish     : Tool initialization (mise, cargo, etc.)
#      - 98_aliases.fish   : Shell aliases
#      - z.fish            : z directory jumping (fisher plugin)
#   2. functions/*.fish (auto-loaded on demand)
#   3. This file (config.fish) - for interactive shell settings
#
# Plugin Management: fisher (fish_plugins file)
#---------------------------

if status is-interactive
    #---------------------------
    # Prompt (pure-fish/pure via fisher)
    #---------------------------
    # pure is loaded by fisher from conf.d/functions, so no init command is needed here.

    #---------------------------
    # Fish-specific Settings
    #---------------------------
    # Disable greeting message
    set -g fish_greeting

    # fish 4.1+: some terminals don't reply to the DA1 (Primary Device Attributes) query fast enough.
    # We disable that startup query via the universal `fish_features` flag `no-query-term`
    # Set as universal variable so it persists across sessions
    set -U fish_features no-query-term

    # Enable vi mode (optional, uncomment if you prefer vi keybindings)
    # fish_vi_key_bindings

    #---------------------------
    # Syntax Highlighting Colors
    #---------------------------
    # Cursor Dark palette
    set -g fish_color_normal d8dee9 # Normal text
    set -g fish_color_command a3be8c # Valid commands
    set -g fish_color_error bf616a # Invalid commands
    set -g fish_color_param aa9bf5 # Command parameters
    set -g fish_color_quote e394dc # Quoted strings
    set -g fish_color_redirection 83d6c5 # Redirections (>, <, |)
    set -g fish_color_end a3be8c # End of command (;, &)
    set -g fish_color_comment 6d6d6d # Comments
    set -g fish_color_autosuggestion 6d6d6d # Autosuggestions
    set -g fish_color_operator 83d6c5 # Operators ($, *, etc.)
    set -g fish_color_escape ebcb8b # Escape sequences (\n, etc.)
    set -g fish_color_selection --background=404040
    set -g fish_color_search_match --background=404040
    # Disable valid_path check to prevent input lag during fast key repeat
    # set -g fish_color_valid_path --underline # Valid file paths
end

fish_add_path -a "/Users/asumayamada/.config/.foundry/bin"
