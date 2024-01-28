local wezterm = require('wezterm')

local M = {}

if wezterm.config_builder then
  M = wezterm.config_builder()
end

local function add_to_config(module)
  for key, value in pairs(module.config) do
    M[key] = value
  end
end

add_to_config(require('user.base'))
add_to_config(require('user.colors'))
add_to_config(require('user.tab-bar'))
add_to_config(require('user.keymaps'))
add_to_config(require('user.mouse'))

require('user.right-status')

return M
