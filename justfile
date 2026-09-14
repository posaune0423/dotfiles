# Repository task runner. Run `just` to list recipes.

set shell := ["sh", "-eu", "-c"]

# List recipes
[private]
default:
    @just --list --unsorted

# Run dotfiles installer
install:
    ./install.sh

# Check formatting (sh/zsh/fish/lua/toml/json)
format:
    ./scripts/format.sh --check

# Apply formatting (sh/zsh/fish/lua/toml/json)
format-fix:
    ./scripts/format.sh

# Run format checks + shellcheck
lint: format
    @echo "Running shellcheck..."
    @shellcheck -S error -s sh install.sh
    @shellcheck -S error -s bash .zshenv .zprofile .zshrc
    @echo "Done."

# Apply format fixes then run lint
lint-fix: format-fix lint
