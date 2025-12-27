#---------------------------
# zsh-autocomplete Plugin
#---------------------------
# https://github.com/marlonrichert/zsh-autocomplete
#
# RESPONSIBILITY:
# - Load zsh-autocomplete plugin
# - Initialize completion system (it handles compinit internally)
# - Configure autocomplete behavior
#---------------------------

#---------------------------
# Pre-load Configuration
#---------------------------
# Must be set BEFORE loading the plugin

zstyle ':autocomplete:*' delay 0.1
zstyle ':autocomplete:*' min-input 1
zstyle -e ':autocomplete:*:*' list-lines 'reply=( $(( LINES / 4 )) )'
zstyle ':autocomplete:history-search-backward:*' list-lines 16
zstyle ':autocomplete:*complete*:*' insert-unambiguous no
zstyle ':autocomplete:*history*:*' insert-unambiguous no
zstyle ':autocomplete:*' add-space ''

#---------------------------
# Load Plugin
#---------------------------
typeset -g _autocomplete_loaded=0
local _plugin_path=""

if [[ -f /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]]; then
  _plugin_path="/opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
elif [[ -f /usr/local/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]]; then
  _plugin_path="/usr/local/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
elif [[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]]; then
  _plugin_path="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
fi

if [[ -n "$_plugin_path" ]]; then
  source "$_plugin_path"
  _autocomplete_loaded=1
fi

#---------------------------
# Post-load Configuration
#---------------------------
if (( _autocomplete_loaded )); then
  # Compatibility Fixes
  bindkey -M main ' ' .self-insert
  bindkey -M emacs ' ' .self-insert
  bindkey -M viins ' ' .self-insert

  # Key Bindings
  bindkey '\t' menu-select
  bindkey "$terminfo[kcbt]" menu-select
  bindkey -M menuselect '\t' menu-complete
  bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
  bindkey -M menuselect '\r' .accept-line
  bindkey -M menuselect '^[[D' .backward-char  '^[OD' .backward-char
  bindkey -M menuselect '^[[C' .forward-char   '^[OC' .forward-char

  # Completion Styles (Override standard styles)
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*:descriptions' format '%F{green}── %d ──%f'
fi

unset _autocomplete_loaded _plugin_path
