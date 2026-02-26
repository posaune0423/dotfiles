.PHONY: help install format format\:fix lint lint\:fix

# Default target
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  install       Run dotfiles installer"
	@echo "  format        Check formatting (sh/zsh/fish/lua/toml/json)"
	@echo "  format:fix    Apply formatting (sh/zsh/fish/lua/toml/json)"
	@echo "  lint          Run format checks + shellcheck"
	@echo "  lint:fix      Apply format fixes then run lint"

# Install dotfiles
install:
	./install.sh

# Check formatting (for CI)
format:
	./scripts/format.sh --check

# Apply formatting fixes
format\:fix:
	./scripts/format.sh

# Lint shell scripts + formatting checks
lint: format
	@echo "Running shellcheck..."
	@shellcheck -S error -s sh install.sh
	@shellcheck -S error -s bash .zshenv .zprofile .zshrc
	@echo "Done."

# Apply formatter fixes then run lint checks
lint\:fix: format\:fix lint
