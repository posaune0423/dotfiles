if vim.g.colors_name then
  vim.cmd("highlight clear")
end

if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.g.colors_name = "cursor_dark"

local c = {
  bg_main = "#141414",
  bg_editor = "#1a1a1a",
  bg_line = "#292929",
  bg_select = "#404040",
  border = "#2a2a2a",
  fg = "#d8dee9",
  fg_muted = "#cccccc",
  comment = "#6d6d6d",
  black = "#2a2a2a",
  red = "#bf616a",
  green = "#a3be8c",
  yellow = "#ebcb8b",
  blue = "#87c3ff",
  magenta = "#b48ead",
  cyan = "#83d6c5",
  orange = "#efb080",
  pink = "#e394dc",
  purple = "#aa9bf5",
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

hl("Normal", { fg = c.fg, bg = c.bg_editor })
hl("NormalNC", { fg = c.fg, bg = c.bg_editor })
hl("NormalFloat", { fg = c.fg, bg = c.bg_main })
hl("FloatBorder", { fg = c.border, bg = c.bg_main })
hl("FloatTitle", { fg = c.fg, bg = c.bg_main, bold = true })
hl("SignColumn", { bg = c.bg_editor })
hl("ColorColumn", { bg = c.bg_line })
hl("CursorLine", { bg = c.bg_line })
hl("CursorColumn", { bg = c.bg_line })
hl("CursorLineNr", { fg = "#ffffff", bg = c.bg_line, bold = true })
hl("LineNr", { fg = "#505050", bg = c.bg_editor })
hl("WinSeparator", { fg = c.border, bg = c.bg_editor })
hl("VertSplit", { fg = c.border, bg = c.bg_editor })
hl("StatusLine", { fg = c.fg_muted, bg = c.bg_main })
hl("StatusLineNC", { fg = "#808080", bg = c.bg_main })
hl("Pmenu", { fg = c.fg, bg = c.bg_main })
hl("PmenuSel", { fg = "#ffffff", bg = c.bg_select })
hl("PmenuSbar", { bg = c.bg_main })
hl("PmenuThumb", { bg = "#505050" })
hl("Visual", { bg = c.bg_select })
hl("Search", { fg = "#ffffff", bg = c.bg_select })
hl("IncSearch", { fg = c.bg_editor, bg = c.cyan, bold = true })
hl("CurSearch", { fg = c.bg_editor, bg = c.cyan, bold = true })
hl("MatchParen", { fg = "#ffffff", bg = "NONE", bold = true })
hl("Folded", { fg = c.comment, bg = c.bg_main })
hl("NonText", { fg = "#505050" })
hl("SpecialKey", { fg = "#505050" })
hl("Whitespace", { fg = "#505050" })

hl("Comment", { fg = c.comment, italic = true })
hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.orange })
hl("Statement", { fg = c.cyan })
hl("Keyword", { fg = c.cyan })
hl("Conditional", { fg = c.cyan })
hl("Repeat", { fg = c.cyan })
hl("Operator", { fg = c.fg_muted })
hl("Type", { fg = c.blue })
hl("Constant", { fg = c.green })
hl("String", { fg = c.pink })
hl("Character", { fg = c.pink })
hl("Number", { fg = "#ebc88d" })
hl("Boolean", { fg = c.cyan })
hl("PreProc", { fg = c.green })
hl("Special", { fg = c.yellow })
hl("Delimiter", { fg = c.fg_muted })
hl("Title", { fg = c.fg, bold = true })

hl("DiagnosticError", { fg = c.red })
hl("DiagnosticWarn", { fg = c.yellow })
hl("DiagnosticInfo", { fg = c.cyan })
hl("DiagnosticHint", { fg = c.blue })
hl("DiagnosticOk", { fg = c.green })
hl("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.cyan })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.blue })

hl("DiffAdd", { fg = c.green, bg = c.bg_main })
hl("DiffChange", { fg = c.yellow, bg = c.bg_main })
hl("DiffDelete", { fg = c.red, bg = c.bg_main })
hl("DiffText", { fg = c.fg, bg = c.bg_line })

hl("GitSignsAdd", { fg = c.green, bg = c.bg_editor })
hl("GitSignsChange", { fg = c.yellow, bg = c.bg_editor })
hl("GitSignsDelete", { fg = c.red, bg = c.bg_editor })

hl("@comment", { link = "Comment" })
hl("@variable", { fg = c.fg })
hl("@variable.builtin", { fg = c.fg })
hl("@variable.parameter", { fg = c.fg })
hl("@property", { fg = c.purple })
hl("@string", { fg = c.pink })
hl("@string.escape", { fg = c.yellow })
hl("@number", { fg = "#ebc88d" })
hl("@boolean", { fg = c.cyan })
hl("@constant", { fg = c.green })
hl("@constant.builtin", { fg = c.cyan })
hl("@function", { fg = c.orange })
hl("@function.builtin", { fg = c.cyan })
hl("@method", { fg = c.orange })
hl("@constructor", { fg = c.orange })
hl("@keyword", { fg = c.cyan })
hl("@keyword.function", { fg = c.cyan })
hl("@keyword.return", { fg = c.cyan })
hl("@type", { fg = c.blue })
hl("@type.builtin", { fg = c.cyan })
hl("@namespace", { fg = c.blue })
hl("@operator", { fg = c.fg_muted })
hl("@punctuation", { fg = c.fg_muted })
hl("@tag", { fg = c.blue })
hl("@tag.attribute", { fg = c.purple })

hl("SnacksDashboardHeader", { fg = c.yellow })
hl("SnacksDashboardIcon", { fg = c.blue })
hl("SnacksDashboardKey", { fg = c.orange })
hl("SnacksDashboardDesc", { fg = c.fg })
hl("SnacksDashboardFooter", { fg = c.green })

vim.g.terminal_color_0 = c.black
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = "#81a1c1"
vim.g.terminal_color_5 = c.magenta
vim.g.terminal_color_6 = "#88c0d0"
vim.g.terminal_color_7 = "#ffffff"
vim.g.terminal_color_8 = "#505050"
vim.g.terminal_color_9 = c.red
vim.g.terminal_color_10 = c.green
vim.g.terminal_color_11 = c.yellow
vim.g.terminal_color_12 = "#81a1c1"
vim.g.terminal_color_13 = c.magenta
vim.g.terminal_color_14 = "#88c0d0"
vim.g.terminal_color_15 = "#ffffff"
