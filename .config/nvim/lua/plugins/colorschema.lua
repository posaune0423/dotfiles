return {
    "Shatur/neovim-ayu",
    config = function()
        require("ayu").setup({
            mirage = true, -- `true` にすると "mirage" バリアントを使用
            overrides = {
                Normal = {
                    bg = "None"
                },
                ColorColumn = {
                    bg = "None"
                },
                SignColumn = {
                    bg = "None"
                },
                Folded = {
                    bg = "None"
                },
                FoldColumn = {
                    bg = "None"
                },
                CursorLine = {
                    bg = "None"
                },
                CursorColumn = {
                    bg = "None"
                },
                WhichKeyFloat = {
                    bg = "None"
                },
                VertSplit = {
                    bg = "None"
                }
            }
        })
        -- カラースキームを適用
        vim.cmd("colorscheme ayu-mirage")
    end
}
