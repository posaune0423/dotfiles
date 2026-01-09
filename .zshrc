#---------------------------
# Load Modular Zsh Configuration
#---------------------------

# Define load order: Core -> Completion -> Features -> Prompt
# NOTE: Plugins (autosuggestions, syntax-highlighting) are managed by sheldon

typeset -a _zsh_configs=(
  core # Basic settings (History, Options)

  # --- Completion ---
  completion # Standard zsh completion (Use this if autocomplete is disabled)

  # --- Features ---
  aliases   # Aliases
  functions # Custom functions
  tools     # Dev tools

  # --- UI ---
  prompt # Starship prompt (Must be initialized last)
)

# Source files in order
for _cfg in "${_zsh_configs[@]}"; do
  [[ -r "$HOME/.config/zsh/${_cfg}.zsh" ]] && source "$HOME/.config/zsh/${_cfg}.zsh"
done

# Clean up
unset _zsh_configs _cfg

#---------------------------
# Sheldon Plugin Manager
#---------------------------
# Load zsh plugins via sheldon (zsh-autosuggestions, zsh-syntax-highlighting, etc.)
if command -v sheldon &> /dev/null; then
  eval "$(sheldon source)"
fi
