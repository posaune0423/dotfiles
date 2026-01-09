#---------------------------
# Kiro CLI Pre-hook
#---------------------------
test -x ~/.local/bin/kiro-cli; and eval (~/.local/bin/kiro-cli init fish pre --rcfile 00_kiro_pre | string split0)
