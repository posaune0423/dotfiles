.PHONY: help install format format-check lint lint-local

# Default target
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  install       Run dotfiles installer"
	@echo "  format        Format shell scripts (sh/zsh/fish)"
	@echo "  format-check  Check formatting without changes"
	@echo "  lint          Run shellcheck on shell scripts (fails on errors)"
	@echo "  lint-local    Run shellcheck on shell scripts (ignores errors)"

# Install dotfiles
install:
	./install.sh

# Format shell scripts
format:
	./scripts/format.sh

# Check formatting (for CI)
format-check:
	./scripts/format.sh --check

# Lint shell scripts with shellcheck (fails on errors, for CI)
lint:
	@echo "Running shellcheck..."
	@shellcheck install.sh
	@shellcheck .zshenv .zprofile
	@echo "Done."

# Lint shell scripts with shellcheck (ignores errors, for local convenience)
lint-local:
	@echo "Running shellcheck..."
	@shellcheck install.sh || true
	@shellcheck .zshenv .zprofile || true
	@echo "Done."
