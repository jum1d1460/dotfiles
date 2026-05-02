-- =============================================================================
-- WezTerm Configuration — Purista / macOS-style
-- ~/.wezterm.lua
-- =============================================================================

local wezterm = require("wezterm")
local act = wezterm.action

-- ─── Theme definitions ────────────────────────────────────────────────────────
local themes = {
  catppuccin = "Catppuccin Macchiato",
  ["tokyo-night"] = "Tokyo Night",
  dracula = "Dracula (Official)",
}

-- ─── Read active theme from ~/.config/current-theme ──────────────────────────
local function read_active_theme()
  local theme_file = wezterm.home_dir .. "/.config/current-theme"
  local f = io.open(theme_file, "r")
  if f then
    local name = f:read("*l"):gsub("%s+", "")
    f:close()
    return themes[name] or themes["catppuccin"]
  end
  return themes["catppuccin"]
end

local active_color_scheme = read_active_theme()

-- ─── Config ───────────────────────────────────────────────────────────────────
local config = wezterm.config_builder()

-- Font & rendering
config.font = wezterm.font_with_fallback({
  { family = "JetBrainsMono Nerd Font", harfbuzz_features = { "calt=1", "liga=1", "clig=1" } },
  "Noto Color Emoji",
})

-- Start zsh login shell so aliases and prompts are always loaded
config.default_prog = { "env", "zsh", "-l" }

config.font_size = 11
config.line_height = 1.0
config.cell_width = 1.0

-- Colour scheme
config.color_scheme = active_color_scheme

-- Show native titlebar controls and resize borders
config.window_decorations = "TITLE|RESIZE"
config.window_padding = { left = 12, right = 12, top = 10, bottom = 10 }

-- Transparency & blur
config.window_background_opacity = 0.90
config.macos_window_background_blur = 20 -- effective on macOS; harmless on Linux
config.text_background_opacity = 1.0

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 30

-- Scrollback
config.scrollback_lines = 10000

-- Bell
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = "CursorColor",
}

-- Performance
config.animation_fps = 60
config.max_fps = 120
config.front_end = "OpenGL"

-- ─── Key bindings ─────────────────────────────────────────────────────────────
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  -- Pane splits (tmux-style)
  { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "|", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

  -- Pane navigation (Vim-style)
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

  -- Pane resize
  { key = "H", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "J", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "K", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "L", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },

  -- Tabs
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "w", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

  -- Copy mode
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },

  -- Font size
  { key = "=", mods = "CTRL",   action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL",   action = act.DecreaseFontSize },
  { key = "0", mods = "CTRL",   action = act.ResetFontSize },
}

return config
