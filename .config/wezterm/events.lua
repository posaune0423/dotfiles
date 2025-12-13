-- ~/.config/wezterm/events.lua
local wezterm = require("wezterm")
local M = {}

function M.apply(config)
  -- opacity toggle: 0.85 <-> 0.5
  wezterm.on("toggle-opacity", function(window, _)
    local overrides = window:get_config_overrides() or {}

    local current = overrides.window_background_opacity
      or config.window_background_opacity
      or 1.0

    -- 0.5と0.85の間の閾値（0.675）で判定して確実にトグル
    overrides.window_background_opacity = (current >= 0.675) and 0.5 or 0.85
    window:set_config_overrides(overrides)
  end)

  -- Ghosttyっぽく「各タブを幅いっぱいに分割して配置」する
  -- ただし“分からなさ”を避けるため:
  -- - アクティブタブ/非アクティブで背景を少し変える（区切り線は使わない）
  -- - tab_bar_style 側で左右に“ギャップ”を作って今っぽく見せる
  wezterm.on("format-tab-title", function(tab, tabs, _panes, cfg, hover, max_width)
    local schemes = wezterm.get_builtin_color_schemes()
    local scheme = schemes and cfg and cfg.color_scheme and schemes[cfg.color_scheme] or nil
    local bg = (scheme and scheme.background) or "#1f2430"
    local fg = (scheme and scheme.foreground) or "#cbccc6"

    -- 画像のUIに合わせた色調整
    -- アクティブタブ: 暗いグレー背景、白文字
    -- 非アクティブタブ: 明るいグレー背景、暗いグレー文字
    local inactive_bg = "#3a3f4e"  -- 明るいグレー（非アクティブ）
    local active_bg = "#2a2d38"    -- 暗いグレー（アクティブ）
    local inactive_fg = "#6b7280"  -- 暗いグレー文字（非アクティブ）
    if hover and not tab.is_active then
      inactive_fg = "#9ca3af"      -- hover時は少し明るく
      inactive_bg = "#404552"
    end

    -- tab.tab_title が設定されていても、active_pane.title を優先して動的に更新されるようにする
    -- （tab.tab_title は一度設定されると固定されてしまうため）
    local title = tab.active_pane.title
    if not title or title == "" then
      title = tab.tab_title or "untitled"
    end

    -- 左右にスペースを入れて見た目を安定させる
    title = "  " .. title .. "  "

    local width = max_width
    if width < 1 then
      width = 1
    end

    -- Ghosttyっぽい“余白(ギャップ)”をタブの左右に入れる（区切り線は使わない）
    -- 余白を小さくしてコンパクトに
    local outer_gap = 0.5
    local inner_width = math.max(1, width - (outer_gap * 2))

    -- 幅に収まるように切り詰め
    local trimmed = wezterm.truncate_right(title, inner_width)
    local trimmed_w = wezterm.column_width(trimmed)

    -- センタリング（余りは右側に寄せる）
    local pad_total = inner_width - trimmed_w
    if pad_total < 0 then
      pad_total = 0
    end
    local pad_left = math.floor(pad_total / 2)
    local pad_right = pad_total - pad_left
    local text = string.rep(" ", pad_left) .. trimmed .. string.rep(" ", pad_right)

    local this_bg = tab.is_active and active_bg or inactive_bg
    local this_fg = tab.is_active and fg or inactive_fg
    local intensity = tab.is_active and "Bold" or "Normal"

    -- 区切り線は使わず、背景差＋左右ギャップで“タブ感”を出す
    -- 余白を小さくするため、半角スペース1個分に調整
    local gap_text = " "
    return {
      { Background = { Color = "none" } },
      { Text = gap_text },
      { Background = { Color = this_bg } },
      { Foreground = { Color = this_fg } },
      { Attribute = { Intensity = intensity } },
      { Text = text },
      { Background = { Color = "none" } },
      { Text = gap_text },
      -- reset（次要素に影響させない）
      { Background = { Color = "none" } },
      { Foreground = { Color = fg } },
      { Attribute = { Intensity = "Normal" } },
    }
  end)

  -- boot full screen when login (元のコメントを保持)
  -- local mux = wezterm.mux
  -- wezterm.on("gui-startup", function(cmd)
  --     local tab, pane, window = mux.spawn_window(cmd or {})
  --     window:gui_window():toggle_fullscreen()
  -- end)
end

return M
