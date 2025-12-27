#---------------------------
# Load Modular Zsh Configuration
#---------------------------

# Define load order: Core -> Completion/Plugins -> Prompt
# Comment out 'plugin/autocomplete' and uncomment 'completion' for standard zsh behavior.
# To use autocomplete, swap them.

typeset -a _zsh_configs=(
  core                        # Basic settings (History, Options)

  # --- Choose ONE completion system ---
  # plugins/autocomplete      # zsh-autocomplete (Handles compinit itself)
  completion                  # Standard zsh completion (Use this if autocomplete is disabled)

  # --- Plugins ---
  plugins/autosuggestions     # zsh-autosuggestions
  plugins/syntax-highlighting # zsh-syntax-highlighting (Should be late)

  # --- Features ---
  aliases                     # Aliases
  functions                   # Custom functions
  tools                       # Dev tools

  # --- UI ---
  prompt                      # Starship prompt (Must be initialized last)
)

# Source files in order
for _cfg in "${_zsh_configs[@]}"; do
  [[ -r "$HOME/.config/zsh/${_cfg}.zsh" ]] && source "$HOME/.config/zsh/${_cfg}.zsh"
done

# Clean up
unset _zsh_configs _cfg
