#---------------------------
# Standard Completion Configuration
#---------------------------
# Native zsh completion system (compinit) setup.
# This should be loaded IF no other advanced completion plugin
# (like zsh-autocomplete) handles initialization.
#---------------------------

# Helper function to check if compinit is already done
function _is_compinit_done() {
  [[ -n "$_comp_dumpfile" ]] || (( $+functions[compdef] ))
}

# Only run if completion system is not yet initialized
if ! _is_compinit_done; then

  # Add homebrew completions to fpath if exists
  if [[ -d /opt/homebrew/share/zsh-completions ]]; then
    fpath=(/opt/homebrew/share/zsh-completions $fpath)
  fi

  # Initialize completion system
  autoload -Uz compinit

  # Use cache for faster completion loading
  if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
fi

#---------------------------
# Completion Styles (Standard)
#---------------------------
# These styles apply to standard zsh completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'           # Case insensitive
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}        # Colorize completions
zstyle ':completion:*' menu select                           # Menu selection
zstyle ':completion:*' group-name ''                         # No group names
zstyle ':completion:*' verbose yes                           # Verbose output
zstyle ':completion:*:descriptions' format '%B%d%b'          # Description format
zstyle ':completion:*:messages' format '%d'                  # Message format
zstyle ':completion:*:warnings' format 'No matches for: %d'  # Warning format
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b' # Correction format

# Kill command completion styles
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
