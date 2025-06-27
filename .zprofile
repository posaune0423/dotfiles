#---------------------------
# Login Shell Configuration (.zprofile)
#---------------------------
# This file is sourced by login shells and should contain
# settings that need to be available to GUI applications

#---------------------------
# GUI Application Environment Variables
#---------------------------
# Make environment variables available to GUI applications on macOS
if [[ "$OSTYPE" == darwin* ]]; then
  # Ensure GUI apps can find development tools
  launchctl setenv PATH "$PATH"

  # Set locale for GUI applications
  launchctl setenv LANG "$LANG"
  launchctl setenv LC_ALL "$LC_ALL"

  # Set editor for GUI applications
  launchctl setenv EDITOR "$EDITOR"
  launchctl setenv VISUAL "$VISUAL"

  # Development tool paths for GUI apps
  [[ -n "$GOPATH" ]] && launchctl setenv GOPATH "$GOPATH"
  [[ -n "$GOROOT" ]] && launchctl setenv GOROOT "$GOROOT"
  [[ -n "$PYENV_ROOT" ]] && launchctl setenv PYENV_ROOT "$PYENV_ROOT"
  [[ -n "$RBENV_ROOT" ]] && launchctl setenv RBENV_ROOT "$RBENV_ROOT"
  [[ -n "$NVM_DIR" ]] && launchctl setenv NVM_DIR "$NVM_DIR"
fi

#---------------------------
# Login-specific Tasks
#---------------------------
# Update locate database (if available)
[[ -x /usr/libexec/locate.updatedb ]] && /usr/libexec/locate.updatedb 2>/dev/null &
