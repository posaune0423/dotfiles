return {
  "Shatur/neovim-ayu",
  config = function()
    require("ayu").setup({
      mirage = true, -- `true` にすると "mirage" バリアントを使用
      styles = {
        sidebars = "dark",
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
          fg = "#8b8fa3", -- テーマに合う控えめなグレー（NonTextと同じ色）
        },
        WinSeparator = {
          bg = "None",
          fg = "#8b8fa3", -- テーマに合う控えめなグレー
        },
        -- サイドバーの背景をエディタと同じ色にする
        NormalFloat = {
          bg = "None",
        },
        NormalNC = {
          bg = "None",
        },
        -- スペース/タブ表示の色を白寄りのグレーに調整（背景透過に合わせる）
        NonText = {
          fg = "#8b8fa3", -- 白寄りのグレー（eol, tab用）
        },
        SpecialKey = {
          fg = "#8b8fa3", -- 白寄りのグレー（trail, lead, space用）
        },
      },
    })
    -- カラースキームを適用
    vim.cmd("colorscheme ayu-mirage")
  end,
}
