-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

-- Unbind <C-l> in terminal mode to allow normal terminal clearing behavior
-- Fixes issue where <C-l> moves cursor to right window instead of clearing terminal
-- Use TermEnter (not TermOpen) to ensure it runs after LazyVim's keymaps are loaded
vim.api.nvim_create_autocmd("TermEnter", {
  pattern = "*",
  callback = function()
    -- Send <C-l> directly to the terminal instead of letting Neovim handle it
    vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", "<C-l>", { noremap = true, silent = true })
  end,
})
