-- ~/.config/wezterm/appearance.lua
local wezterm = require("wezterm")
local M = {}

function M.apply(config)
  config.exit_behavior = "Close"
  -- terminalを閉じる時の確認を出さない
  config.window_close_confirmation = "NeverPrompt"

  -- colorscheme
  config.color_scheme = "Ayu Mirage"

  -- tab
  -- Ghosttyっぽく「幅いっぱいに分割」したいので retro tab bar を使う
  config.use_fancy_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = true
  -- 新しいタブボタン（+）を表示（画像のUIに合わせる）
  config.show_new_tab_button_in_tab_bar = true
  -- できるだけタブ幅の上限で詰まらないよう大きめに
  config.tab_max_width = 200
  -- 標準タイトルバーを消す（macOSのtraffic lightボタンはシステム側で一段上に表示される）
  config.window_decorations = "RESIZE"

  -- タブバーのフォントサイズを小さく
  config.window_frame = config.window_frame or {}
  config.window_frame.font_size = 10.0

  -- background
  config.window_background_opacity = 0.85
  -- iOS 26 の丸角に合わせて、上と左右に余白を増やす
  config.window_padding = {
    left = 18,
    right = 18,
    top = 16,
    bottom = 12,
  }

  -- tab部分/タイトルバー含めて同系色に揃える（透過は window_background_opacity で効く）
  local schemes = wezterm.get_builtin_color_schemes()
  local scheme = schemes and schemes[config.color_scheme] or nil
  local bg = (scheme and scheme.background) or "#1f2430"
  local fg = (scheme and scheme.foreground) or "#cbccc6"

  config.colors = config.colors or {}
  config.colors.tab_bar = {
    -- retro tab bar の透過は `background = "none"` が効く。
    -- 背景色は window_background_gradient に任せて「同じ色」に見せる。
    background = "none",
    inactive_tab_edge = "none",
    active_tab = {
      bg_color = "none",
      fg_color = fg,
      intensity = "Bold",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = "none",
      fg_color = fg,
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab_hover = {
      bg_color = "none",
      fg_color = fg,
      italic = false,
    },
    new_tab = {
      bg_color = "none",
      fg_color = fg,
    },
    new_tab_hover = {
      bg_color = "none",
      fg_color = fg,
      italic = false,
    },
  }

  -- 背景を単色で統一（tab bar を "none" にした時に「同じ色」に見える）
  config.window_background_gradient = {
    colors = { bg },
  }

  -- タイトルバーも透過して背景と同化させる（記事のやり方）
  config.window_frame.active_titlebar_bg = "none"
  config.window_frame.inactive_titlebar_bg = "none"

  -- tab area 全体に“内側の余白”を作る（丸角との干渉を避ける）
  -- border_* は window_frame の内側に描画されるので、タブ領域にも効く
  config.window_frame.border_left_width = "14px"
  config.window_frame.border_right_width = "14px"
  config.window_frame.border_top_height = "12px"
  config.window_frame.border_bottom_height = "10px"
  config.window_frame.border_left_color = bg
  config.window_frame.border_right_color = bg
  config.window_frame.border_top_color = bg
  config.window_frame.border_bottom_color = bg

  -- NOTE:
  -- wezterm 20240203 では tab_bar_style に `active_tab_left/right` が存在しないため、
  -- 見た目の“ギャップ”は events.lua の format-tab-title 側で描画する。
end

return M
