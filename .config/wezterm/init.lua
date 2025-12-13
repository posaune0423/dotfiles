-- ~/.config/wezterm/init.lua
local wezterm = require("wezterm")
local config = wezterm.config_builder()

require("config.wezterm.appearance").apply(config)
require("config.wezterm.font").apply(config)
require("config.wezterm.events").apply(config)
require("config.wezterm.keys").apply(config)

return config
