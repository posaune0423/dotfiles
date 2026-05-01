#---------------------------
# PATH construction (shared)
#---------------------------
# Sourced from ~/.zshenv after path_prepend/path_append are defined.
# Keeps login vs interactive duplication out of .zprofile / .zshrc.

# --- OS package managers (bootstrap) ---
path_prepend "/opt/homebrew/bin"
path_prepend "/opt/homebrew/sbin"
path_prepend "/usr/local/bin"
path_prepend "$HOME/bin"

# --- mise (version manager shims; no eval) ---
path_prepend "${MISE_DATA_DIR:-$HOME/.local/share/mise}/shims"
path_prepend "${MISE_DATA_DIR:-$HOME/.local/share/mise}/bin"

# --- User-local CLI installs (pip/pipx --user, etc.) ---
path_prepend "$HOME/.local/bin"

# --- Node / JS ---
path_append "$PNPM_HOME"

# --- Bun ---
path_append "$HOME/.cache/.bun/bin"

# --- LM Studio CLI (lms) ---
path_append "$HOME/.cache/lm-studio/bin"

# --- Go (mise manages toolchain; GOPATH/bin for go install) ---
path_append "$GOPATH/bin"

# --- Solana ---
path_prepend "$HOME/.local/share/solana/install/active_release/bin"

# --- Obsidian (CLI shim on macOS) ---
path_append "/Applications/Obsidian.app/Contents/MacOS"
