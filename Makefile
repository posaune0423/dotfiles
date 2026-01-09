.PHONY: help install format format-check lint

# Default target
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  install       Run dotfiles installer"
	@echo "  format        Format shell scripts (sh/zsh/fish)"
	@echo "  format-check  Check formatting without changes"
	@echo "  lint          Run shellcheck on shell scripts"

# Install dotfiles
install:
	./install.sh

# Format shell scripts
format:
	./scripts/format

# Check formatting (for CI)
format-check:
	./scripts/format --check

# Lint shell scripts with shellcheck
lint:
	@echo "Running shellcheck..."
	@shellcheck install.sh || true
	@shellcheck .zshenv .zprofile || true
	@echo "Done."
