-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.exit_behavior = 'Close'

-- For example, changing the color scheme:
config.color_scheme = 'Ayu Mirage'

-- Tab config
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true



-- Background tranparent
config.window_background_opacity = 0.85

-- boot full screen when login
-- local mux = wezterm.mux
-- wezterm.on("gui-startup", function(cmd)
--     local tab, pane, window = mux.spawn_window(cmd or {})
--     window:gui_window():toggle_fullscreen()
-- end)


-- font config
config.font = wezterm.font("SauceCodePro Nerd Font", {weight="Medium", stretch="Normal", style="Normal"})

-- font config
config.font_size = 16
config.line_height = 1.1

-- shortcut key config
local act = wezterm.action
config.keys = {
  -- cmd+t to create new tab
  {
    key = 't',
    mods = 'CMD',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  -- cmd+d to create new pain
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '[',
    mods = 'CMD',
    action = act.ActivateTabRelative(-1)
  },
  {
    key = ']',
    mods = 'CMD',
    action = act.ActivateTabRelative(1)
  },
    {
    key = '[',
    mods = 'CMD|SHIFT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = ']',
    mods = 'CMD|SHIFT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'CMD|SHIFT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'CMD|SHIFT',
    action = act.ActivatePaneDirection 'Down',
  }
}

return config
