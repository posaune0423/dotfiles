-- ~/.config/wezterm/font.lua
local wezterm = require("wezterm")
local M = {}

function M.apply(config)
  config.font = wezterm.font("SauceCodePro Nerd Font", {
    weight = "Medium",
    stretch = "Normal",
    style = "Normal",
  })
  config.font_size = 16
  config.line_height = 1.1
end

return M
