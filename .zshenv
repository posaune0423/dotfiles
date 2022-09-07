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

# openjdk
export PATH="/usr/local/opt/openjdk@11/bin:$PATH"

# nvm setting
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# load rbenv
export PATH="$HOME/.rbenv/bin:$PATH"

# For Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# pyenv settings
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
