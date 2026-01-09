local wezterm = require("wezterm")

return {
  enable_wayland = true,

  -- Font
  font = wezterm.font_with_fallback({
    "JetBrains Mono",
    "Noto Color Emoji",
  }),
  font_size = 13,

  -- Performance
  front_end = "WebGpu",
  max_fps = 144,
  animation_fps = 1,

  -- UI
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  window_decorations = "NONE",
  window_padding = { left = 6, right = 6, top = 6, bottom = 6 },

  -- Gruvbox Dark
  colors = {
    foreground = "#ebdbb2",
    background = "#282828",

    cursor_bg = "#ebdbb2",
    cursor_border = "#ebdbb2",
    cursor_fg = "#282828",

    selection_fg = "#282828",
    selection_bg = "#fabd2f",

    ansi = {
      "#282828", -- black
      "#cc241d", -- red
      "#98971a", -- green
      "#d79921", -- yellow
      "#458588", -- blue
      "#b16286", -- purple
      "#689d6a", -- aqua
      "#a89984", -- gray
    },
    brights = {
      "#928374",
      "#fb4934",
      "#b8bb26",
      "#fabd2f",
      "#83a598",
      "#d3869b",
      "#8ec07c",
      "#ebdbb2",
    },
  },

  -- Cursor
  default_cursor_style = "BlinkingBlock",
  cursor_blink_rate = 500,

  -- Clipboard
  keys = {
    { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
  },

  use_ime = false,
}

