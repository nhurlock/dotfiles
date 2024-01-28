local wezterm = require('wezterm')
local colors = require('user.colors')

local M = {}

M.config = {}

local tab_bar = colors.colors.tab_bar

local right_status_separator = wezterm.nerdfonts.ple_upper_left_triangle

local new_tab_style = tab_bar.new_tab
local new_tab_hover_style = tab_bar.new_tab_hover

local tab_bar_style = {}

local function create_window_action(name, color, index)
  local append_first_space = ''
  local append_last_space = ''
  if index == 1 then append_first_space = ' ' end
  if index == 3 then append_last_space = ' ' end
  tab_bar_style[name] = wezterm.format({
    { Background = { Color = tab_bar.background } },
    { Foreground = { Color = colors[color] } },
    { Text = append_first_space .. wezterm.nerdfonts.cod_circle_large_filled .. append_last_space },
    { Background = { Color = tab_bar.background } },
    { Foreground = { Color = tab_bar.background } },
    { Text = right_status_separator },
  })
  tab_bar_style[name .. '_hover'] = wezterm.format({
    { Background = { Color = tab_bar.background } },
    { Foreground = { Color = colors['bright_' .. color] } },
    { Text = append_first_space .. wezterm.nerdfonts.cod_circle_large .. append_last_space },
    { Background = { Color = tab_bar.background } },
    { Foreground = { Color = tab_bar.background } },
    { Text = right_status_separator },
  })
end

create_window_action('window_close', 'red', 1)
create_window_action('window_hide', 'yellow', 2)
create_window_action('window_maximize', 'green', 3)

tab_bar_style.new_tab = wezterm.format({
  { Background = { Color = new_tab_style.bg_color } },
  { Foreground = { Color = tab_bar.background } },
  { Text = right_status_separator },

  { Background = { Color = new_tab_style.bg_color } },
  { Foreground = { Color = new_tab_style.fg_color } },
  { Text = ' + ' },

  { Background = { Color = tab_bar.background } },
  { Foreground = { Color = new_tab_style.bg_color } },
  { Text = right_status_separator },
})

tab_bar_style.new_tab_hover = wezterm.format({
  { Background = { Color = new_tab_hover_style.bg_color } },
  { Foreground = { Color = tab_bar.background } },
  { Text = right_status_separator },

  { Background = { Color = new_tab_hover_style.bg_color } },
  { Foreground = { Color = new_tab_hover_style.fg_color } },
  { Text = ' + ' },

  { Background = { Color = tab_bar.background } },
  { Foreground = { Color = new_tab_hover_style.bg_color } },
  { Text = right_status_separator },
})

M.config.tab_bar_style = tab_bar_style
M.config.tab_max_width = 32

local function tab_title(tab)
  local title = tab.tab_title
  if title and #title > 0 then
    return ': ' .. title .. ' '
  end
  return ' '
end

wezterm.on('format-tab-title', function(tab, _, _, _, hover)
  local tab_type = 'active_tab'
  if not tab.is_active then tab_type = 'inactive_tab' end
  if hover then tab_type = tab_type .. '_hover' end
  local tab_style = tab_bar[tab_type]
  if tab.is_active then tab_style.bg_color = colors.green end
  local separator_style = {
    bg_color = tab_style.bg_color,
    fg_color = tab_bar.background
  }
  return {
    { Background = { Color = separator_style.bg_color } },
    { Foreground = { Color = separator_style.fg_color } },
    { Text = right_status_separator },

    { Background = { Color = tab_style.bg_color } },
    { Foreground = { Color = tab_style.fg_color } },
    { Text = ' ' .. (tab.tab_index + 1) .. tab_title(tab) },
    { Background = { Color = separator_style.fg_color } },
    { Foreground = { Color = separator_style.bg_color } },
    { Text = right_status_separator },
  }
end)

return M
