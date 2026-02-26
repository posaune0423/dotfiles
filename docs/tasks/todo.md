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
