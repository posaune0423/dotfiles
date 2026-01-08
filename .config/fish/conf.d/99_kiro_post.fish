#---------------------------
# Kiro CLI Post-hook
#---------------------------
test -x ~/.local/bin/kiro-cli; and eval (~/.local/bin/kiro-cli init fish post --rcfile 99_kiro_post | string split0)