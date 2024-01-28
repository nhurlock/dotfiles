local wezterm = require('wezterm')

local M = {}

M.config = {}

M.config.color_scheme = 'Catppuccin Macchiato'

M.colors = wezterm.color.get_builtin_schemes()[M.config.color_scheme]

M.bg = M.colors.background

M.white = M.colors.foreground
M.black = M.colors.tab_bar.background

-- base
M.gray = M.colors.ansi[1]
M.red = M.colors.ansi[2]
M.green = M.colors.ansi[3]
M.yellow = M.colors.ansi[4]
M.blue = M.colors.ansi[5]
M.pink = M.colors.ansi[6]
M.teal = M.colors.ansi[7]
M.light_gray = M.colors.ansi[8]

-- brights
M.bright_gray = M.colors.brights[1]
M.bright_red = M.colors.brights[2]
M.bright_green = M.colors.brights[3]
M.bright_yellow = M.colors.brights[4]
M.bright_blue = M.colors.brights[5]
M.bright_pink = M.colors.brights[6]
M.bright_teal = M.colors.brights[7]
M.bright_light_gray = M.colors.brights[8]

-- extras
M.purple = M.colors.tab_bar.active_tab.bg_color

return M
