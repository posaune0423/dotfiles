-- ~/.config/wezterm/keys.lua
local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

function M.apply(config)
  config.keys = {
    -- cmd+t to create new tab
    { key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },

    -- cmd+d to split horizontal (元設定を維持)
    { key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

    -- tabs
    { key = "[", mods = "CMD", action = act.ActivateTabRelative(-1) },
    { key = "]", mods = "CMD", action = act.ActivateTabRelative(1) },

    -- panes
    { key = "[", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Left") },
    { key = "]", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Right") },
    { key = "UpArrow", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Up") },
    { key = "DownArrow", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Down") },

    -- opacity toggle: 0.85 <-> 0.5
    { key = "O", mods = "CMD|SHIFT", action = act.EmitEvent("toggle-opacity") },
  }
end

return M
