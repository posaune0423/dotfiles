#---------------------------
# UI & Enhancement
#---------------------------

#---------------------------
# Zsh Plugins
#---------------------------
# Autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#---------------------------
# Prompt Settings (VCS Info - Disabled, Using Starship)
#---------------------------

# VCS info setup (disabled but kept for reference)
autoload -Uz vcs_info
setopt prompt_subst

# Git status configuration
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

# Prompt format (disabled - using starship)
# PROMPT='%T %n %~ %F{magenta}$%f '
# RPROMPT='${vcs_info_msg_0_}'

#---------------------------
# Starship Prompt
#---------------------------
eval "$(starship init zsh)"