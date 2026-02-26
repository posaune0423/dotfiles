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

---

# CI Workflow Rename and Cleanup

## Plan

- [x] Replace workflow filename with `ci.yml`
- [x] Use clear workflow/job names
- [x] Ensure CI runs `make format` and `make lint`
- [ ] Re-run local `make format` and `make lint`

## Review

- Pending

### Review Update

- [x] Local verification complete: `make format`, `make lint`
- Workflow file changed to `.github/workflows/ci.yml`
- Workflow/job names are now explicit and readable

---

# Ghostty Cursor Dark Custom Theme

## Plan

- [x] Add a Ghostty custom theme file `Cursor Dark` under `.config/ghostty/themes/`
- [x] Populate theme colors to match existing Cursor Dark palette used in this dotfiles repo
- [x] Switch Ghostty config to use `theme = Cursor Dark` without conflicting color overrides
- [x] Verify resulting files and summarize usage

## Review

- Added `.config/ghostty/themes/Cursor Dark` with Cursor Dark-aligned palette and UI colors
- Updated `.config/ghostty/config` to use `theme = Cursor Dark`
- Removed direct `background` override from config to avoid theme color conflicts

---

# CI install-action jq Failure Fix

## Plan

- [x] Reproduce and pinpoint the CI failure root cause from logs and workflow config
- [x] Update workflow tool installation to avoid cargo-binstall jq failure
- [x] Run local verification commands relevant to format/lint workflow
- [x] Document review results

## Review

- Root cause: `taiki-e/install-action@v2` does not support `jq`, causing fallback to `cargo-binstall` and failure on non-binary `jq` crate
- Fix: install `jq` via `apt-get` and remove `jq` from install-action tool list in both CI jobs
- Validation: local `make format` and `make lint` passed

---

# README Latest Settings Sync

## Plan

- [x] Align installer behavior section with current `install.sh` symlink targets
- [x] Sync plugin/tool inventory (`fish_plugins`, `mise`) with current config files
- [x] Update VS Code/Cursor extension reference table from `.vscode/settings.json`
- [x] Update CI section to current workflow and make targets
- [x] Review README diff for consistency and completeness

## Review

- Installer section now reflects current symlink targets: `.commit_template`, `settings.json` and `keybindings.json`, plus `Code - Insiders` path
- Fish plugin inventory now matches `.config/fish/fish_plugins` (`pure-fish/pure`)
- `mise` inventory now includes current code-quality tools (`shfmt`, `shellcheck`, `stylua`, `taplo`) and `usage`
- VS Code/Cursor extension table now matches the formatter extension IDs used in `.vscode/settings.json`
- CI section now points to `make format` / `make lint` and `.github/workflows/ci.yml`
