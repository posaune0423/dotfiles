# Cursor Dark for Fish + Neovim

## Plan

- [x] Confirm fish and nvim theme entry points in this dotfiles repo
- [x] Apply Cursor Dark palette to fish syntax colors
- [x] Add local `cursor_dark` colorscheme for Neovim
- [x] Switch Neovim default colorscheme to `cursor_dark`
- [x] Review diffs and validate file integrity

## Review

- Fish now uses Cursor Dark-like syntax colors directly from `config.fish`
- Neovim now loads a local colorscheme at `colors/cursor_dark.lua`
- `LazyVim` default colorscheme now points to `cursor_dark`

---

# Makefile Targets + Multi-file Formatter

## Plan

- [x] Replace `lint-local` with `format`, `format:fix`, `lint`, `lint:fix`
- [x] Extend formatter coverage to `fish`, `lua`, `toml`, `json`, `sh`
- [x] Ensure `format` is check-only and `format:fix` applies changes
- [x] Add GitHub Actions job to run `make lint`
- [x] Verify locally with `make format` and `make lint`

## Review

- `Makefile` now exposes `format`, `format:fix`, `lint`, `lint:fix`
- `scripts/format.sh` now handles `fish/lua/json/sh`, and `toml` when `taplo` is available
- JSONC files are explicitly skipped (`.vscode/*.json`) to avoid invalid strict-JSON formatting
- `.github/workflows/stylua.yml` now runs a unified lint job via `make lint`
- Local verification passed: `make format`, `make lint`
