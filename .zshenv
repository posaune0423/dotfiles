export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/bin/:$PATH

# env vars
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8


# openssl settings
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

# for pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# pyenv settings
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -path)"

# openjdk
export PATH="/usr/local/opt/openjdk@11/bin:$PATH"


# setting for nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH
