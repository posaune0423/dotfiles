return({
  "Shatur/neovim-ayu",
  config = function()
    require("ayu").setup({
      mirage = false, -- ayu-dark に寄せる
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      overrides = {
        Normal = {
          bg = "None",
        },
        ColorColumn = {
          bg = "None",
        },
        SignColumn = {
          bg = "None",
        },
        Folded = {
          bg = "None",
        },
        FoldColumn = {
          bg = "None",
        },
        CursorLine = {
          bg = "None",
        },
        CursorColumn = {
          bg = "None",
        },
        WhichKeyFloat = {
          bg = "None",
        },
        VertSplit = {
          bg = "None",
          fg = "#3F4656", -- ayu dark寄りの控えめな区切り線
        },
        WinSeparator = {
          bg = "None",
          fg = "#3F4656", -- ayu dark寄りの控えめな区切り線
        },
        -- サイドバーの背景をエディタと同じ色にする
        NormalFloat = {
          bg = "None",
        },
        NormalNC = {
          bg = "None",
        },
        -- スペース/タブ表示の色（控えめに）
        NonText = {
          fg = "#232834", -- ui.fg を bg に薄くブレンドした近似（控えめ）
        },
        SpecialKey = {
          fg = "#232834", -- trail, lead, space 用
        },
        Whitespace = {
          fg = "#232834", -- space, tab, lead, trail 用
        },
        -- Dashboard colors (snacks.nvim)
        SnacksDashboardHeader = {
          fg = "#ffcc66", -- ayu-mirage accent (golden)
        },
        SnacksDashboardIcon = {
          fg = "#73d0ff", -- ayu-mirage blue
        },
        SnacksDashboardKey = {
          fg = "#ffa759", -- ayu-mirage orange
        },
        SnacksDashboardDesc = {
          fg = "#cbccc6", -- ayu-mirage foreground
        },
        SnacksDashboardFooter = {
          fg = "#bae67e", -- ayu-mirage green
        },
      },
    })
    -- カラースキームを適用
    vim.cmd("colorscheme ayu-dark")
  end,
})
