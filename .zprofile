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
  launchctl setenv PATH "$PATH" 2>/dev/null

  # Set locale for GUI applications
  launchctl setenv LANG "$LANG" 2>/dev/null
  launchctl setenv LC_ALL "$LC_ALL" 2>/dev/null

  # Set editor for GUI applications
  launchctl setenv EDITOR "$EDITOR" 2>/dev/null
  launchctl setenv VISUAL "$VISUAL" 2>/dev/null

  # Development tool paths for GUI apps
  [[ -n "$GOPATH" ]] && launchctl setenv GOPATH "$GOPATH" 2>/dev/null
  [[ -n "$GOROOT" ]] && launchctl setenv GOROOT "$GOROOT" 2>/dev/null
  [[ -n "$PYENV_ROOT" ]] && launchctl setenv PYENV_ROOT "$PYENV_ROOT" 2>/dev/null
  [[ -n "$RBENV_ROOT" ]] && launchctl setenv RBENV_ROOT "$RBENV_ROOT" 2>/dev/null
  [[ -n "$NVM_DIR" ]] && launchctl setenv NVM_DIR "$NVM_DIR" 2>/dev/null
fi
