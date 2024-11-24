local wezterm = require('wezterm')
local colors = require('user.colors')

local left_status_separator = wezterm.nerdfonts.ple_upper_right_triangle

-- cached battery level, check every 10 refresh cycles
local get_batt_level = (function()
  local refresh_interval = 10
  local battery_level

  local function refresh_batt_level()
    local wezterm_battery_info = wezterm.battery_info()
    if not wezterm_battery_info or not wezterm_battery_info[1] or wezterm_battery_info[1].state_of_charge ~= wezterm_battery_info[1].state_of_charge then
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

local function to_right_status_part(text, bg, fg)
  if text == nil then text = "" end
  if bg == nil then bg = colors.white end
  if fg == nil then fg = colors.black end
  return {
    { Foreground = { Color = bg } },
    { Text = left_status_separator },

    { Foreground = { Color = fg } },
    { Background = { Color = bg } },
    { Text = " " .. text .. " " }
  }
end

local function merge_tables(tb1, tb2)
  for _, item in ipairs(tb2) do
    table.insert(tb1, item)
  end
end

local function update_right_status(window)
  local right_status = {}

  if window:active_key_table() ~= nil and window:active_key_table() then
    merge_tables(right_status, to_right_status_part(window:active_key_table(), colors.bright_red))
  end

  if window:leader_is_active() then
    merge_tables(right_status, to_right_status_part("L", colors.yellow))
  end

  if wezterm.mux.get_active_workspace() ~= "default" then
    merge_tables(right_status, to_right_status_part(wezterm.mux.get_active_workspace(), colors.purple))
  end

  merge_tables(right_status, to_right_status_part(get_batt_level()))
  merge_tables(right_status, to_right_status_part(get_date_time(), colors.blue))

  -- window:set_right_status(wezterm.format(right_status))
  window:set_right_status('')
end

wezterm.on("update-right-status", update_right_status)
