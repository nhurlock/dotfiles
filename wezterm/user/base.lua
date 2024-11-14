local wezterm = require('wezterm')
local is_desktop = string.match(tostring(os.getenv('OS')), 'Windows')

local M = {}

M.config = {}

-- remove the title bar from the term window, add integrated buttons
M.config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
M.config.integrated_title_button_style = "Windows"
M.config.integrated_title_button_alignment = "Left"
M.config.integrated_title_buttons = { "Close", "Hide", "Maximize" }

M.config.adjust_window_size_when_changing_font_size = false

-- only has an effect on macos
M.config.native_macos_fullscreen_mode = true

M.config.default_cursor_style = "SteadyBar"

-- M.config.window_background_opacity = 1
-- M.config.macos_window_background_blur = 20

if is_desktop then
  M.config.default_domain = "WSL:Ubuntu"
end

-- use discrete graphics
M.config.front_end = "WebGpu"
M.config.webgpu_power_preference = "HighPerformance"
M.config.webgpu_preferred_adapter = wezterm.gui.enumerate_gpus()[1]
M.config.animation_fps = 10
M.config.max_fps = 120

M.config.use_fancy_tab_bar = false
M.config.hide_tab_bar_if_only_one_tab = false

M.config.enable_scroll_bar = false

M.config.window_padding = {
  left = '0cell',
  right = '0cell',
  top = '0cell',
  bottom = '0cell',
}

M.config.allow_square_glyphs_to_overflow_width = "Never"
M.config.font = wezterm.font({ family = 'JetBrainsMono Nerd Font Mono' })
M.config.font_rules = {
  {
    intensity = 'Half',
    italic = false,
    font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Thin", stretch = "Normal", style = "Normal" })
  },
  {
    intensity = 'Half',
    italic = true,
    font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Thin", stretch = "Normal", style = "Italic" })
  },
  {
    intensity = 'Normal',
    italic = false,
    font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Light", stretch = "Normal", style = "Normal" })
  },
  {
    intensity = 'Normal',
    italic = true,
    font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Light", stretch = "Normal", style = "Italic" })
  },
  {
    intensity = 'Bold',
    italic = false,
    font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Bold", stretch = "Normal", style = "Normal" })
  },
  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Bold", stretch = "Normal", style = "Italic" })
  }
}
M.config.font_size = 17.0
-- lower dpi on desktop
if is_desktop then
  M.config.font_size = 14.0
end

return M
