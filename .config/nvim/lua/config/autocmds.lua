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
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    -- unbind <c-l> in terminal
    vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", "<C-l>", { noremap = true, silent = true })
  end,
})
