local wezterm = require('wezterm')
local colors = require('user.colors')

local left_status_separator = wezterm.nerdfonts.ple_upper_right_triangle

-- cached battery level, check every 10 refresh cycles
local get_batt_level = (function()
  local refresh_interval = 10
  local battery_level

  local function refresh_batt_level()
    local wezterm_battery_info = wezterm.battery_info()
    if not wezterm_battery_info or not wezterm_battery_info[1] then
      return wezterm.nerdfonts.fa_bolt
    end
    local battery_info = wezterm_battery_info[1]
    local state_of_charge = battery_info.state_of_charge * 100
    local charge_percent = string.format("%.0f%%", state_of_charge)

    local battery_icon_modifier = ''
    if charge_percent ~= "100%" then
      if battery_info.state == 'Charging' then
        battery_icon_modifier = '_charging_'
      else
        battery_icon_modifier = '_'
      end
      battery_icon_modifier = battery_icon_modifier .. tostring(math.floor(state_of_charge / 10) * 10)
    end

    local battery_icon = wezterm.nerdfonts['md_battery' .. battery_icon_modifier]
    if battery_icon then
      return battery_icon .. " " .. charge_percent
    else
      return ''
    end
  end

  battery_level = refresh_batt_level()

  return function()
    if refresh_interval == 0 then
      battery_level = refresh_batt_level()
      refresh_interval = 10
    else
      refresh_interval = refresh_interval - 1
    end
    return battery_level
  end
end)()

local function get_date_time()
  return wezterm.strftime("%a %b %-d %I:%M %p");
end

local function update_right_status(window)
  local right_status = {}
  local base_info = {
    { Foreground = { Color = colors.white } },
    { Text = left_status_separator },

    { Foreground = { Color = colors.black } },
    { Background = { Color = colors.white } },
    { Text = " " .. get_batt_level() .. " " },

    { Foreground = { Color = colors.blue } },
    { Text = left_status_separator },

    { Foreground = { Color = colors.black } },
    { Background = { Color = colors.blue } },
    { Text = " " .. get_date_time() .. " " },
  }

  if window:active_key_table() ~= nil and window:active_key_table() then
    local key_table_info = {
      { Foreground = { Color = colors.bright_red } },
      { Text = left_status_separator },

      { Foreground = { Color = colors.black } },
      { Background = { Color = colors.bright_red } },
      { Text = " " .. window:active_key_table() .. " " },
    }
    for _, item in ipairs(key_table_info) do
      table.insert(right_status, item)
    end
  end

  if wezterm.mux.get_active_workspace() ~= "default" then
    local workspace_info = {
      { Foreground = { Color = colors.purple } },
      { Text = left_status_separator },

      { Foreground = { Color = colors.black } },
      { Background = { Color = colors.purple } },
      { Text = " " .. wezterm.mux.get_active_workspace() .. " " },
    }
    for _, item in ipairs(workspace_info) do
      table.insert(right_status, item)
    end
  end

  for _, item in ipairs(base_info) do
    table.insert(right_status, item)
  end

  window:set_right_status(wezterm.format(right_status))
end

wezterm.on("update-right-status", update_right_status)
