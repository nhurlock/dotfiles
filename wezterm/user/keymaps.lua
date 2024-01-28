local wezterm = require('wezterm')

local act = wezterm.action

local M = {}

M.config = {}

M.config.leader = { key = "s", mods = "CTRL" }

M.config.disable_default_key_bindings = true

M.config.keys = {
  -- panes
  {
    key = "a",
    mods = "LEADER",
    action = act({
      ActivateKeyTable = { name = "adjust_pane_size", one_shot = false }
    })
  },
  { key = "h",  mods = "LEADER",       action = act({ ActivatePaneDirection = "Left" }) },
  { key = "j",  mods = "LEADER",       action = act({ ActivatePaneDirection = "Down" }) },
  { key = "k",  mods = "LEADER",       action = act({ ActivatePaneDirection = "Up" }) },
  { key = "l",  mods = "LEADER",       action = act({ ActivatePaneDirection = "Right" }) },
  { key = "H",  mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Left", 5 } }) },
  { key = "J",  mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Down", 5 } }) },
  { key = "K",  mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Up", 5 } }) },
  { key = "L",  mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Right", 5 } }) },
  { key = "x",  mods = "LEADER",       action = act({ CloseCurrentPane = { confirm = true } }) },
  { key = "s",  mods = "LEADER",       action = act({ PaneSelect = { mode = "SwapWithActive" } }) },
  { key = "z",  mods = "LEADER",       action = "TogglePaneZoomState" },

  -- splits
  { key = "-",  mods = "LEADER",       action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
  { key = "\\", mods = "LEADER",       action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },

  -- tabs
  {
    key = "t",
    mods = "LEADER",
    action = act({
      ActivateKeyTable = { name = "tab_selection", one_shot = false }
    })
  },
  {
    key = "m",
    mods = "LEADER",
    action = act({
      ActivateKeyTable = { name = "move_tab", one_shot = false }
    })
  },
  { key = "c", mods = "LEADER",       action = act({ SpawnTab = "CurrentPaneDomain" }) },
  { key = "[", mods = "LEADER",       action = act({ ActivateTabRelative = -1 }) },
  { key = "]", mods = "LEADER",       action = act({ ActivateTabRelative = 1 }) },
  { key = "1", mods = "LEADER",       action = act({ ActivateTab = 0 }) },
  { key = "2", mods = "LEADER",       action = act({ ActivateTab = 1 }) },
  { key = "3", mods = "LEADER",       action = act({ ActivateTab = 2 }) },
  { key = "4", mods = "LEADER",       action = act({ ActivateTab = 3 }) },
  { key = "5", mods = "LEADER",       action = act({ ActivateTab = 4 }) },
  { key = "6", mods = "LEADER",       action = act({ ActivateTab = 5 }) },
  { key = "7", mods = "LEADER",       action = act({ ActivateTab = 6 }) },
  { key = "8", mods = "LEADER",       action = act({ ActivateTab = 7 }) },
  { key = "9", mods = "LEADER",       action = act({ ActivateTab = 8 }) },
  -- single pane tabs can be closed just using the non-shift pane-close keymap
  { key = "x", mods = "LEADER|SHIFT", action = act({ CloseCurrentTab = { confirm = true } }) },
  {
    key = "r",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end)
    })
  },

  -- misc
  { key = "n", mods = "LEADER", action = "ToggleFullScreen" },
  { key = ",", mods = "LEADER", action = "ShowDebugOverlay" }
}

M.config.key_tables = {
  tab_selection = {
    { key = 'h',      action = act({ ActivateTabRelative = -1 }) },
    { key = 'l',      action = act({ ActivateTabRelative = 1 }) },
    { key = 'Escape', action = 'PopKeyTable' }
  },
  adjust_pane_size = {
    { key = "h",      action = act({ AdjustPaneSize = { "Left", 5 } }) },
    { key = "j",      action = act({ AdjustPaneSize = { "Down", 5 } }) },
    { key = "k",      action = act({ AdjustPaneSize = { "Up", 5 } }) },
    { key = "l",      action = act({ AdjustPaneSize = { "Right", 5 } }) },
    { key = 'Escape', action = 'PopKeyTable' }
  },
  move_tab = {
    { key = "h",      action = act({ MoveTabRelative = -1 }) },
    { key = "l",      action = act({ MoveTabRelative = 1 }) },
    { key = 'Escape', action = 'PopKeyTable' }
  }
}

local super = "SUPER"
if string.match(tostring(os.getenv('OS')), "Windows") then
  super = "CTRL|SHIFT"

  -- fonts, the SHIFT key will change the actual key value
  table.insert(M.config.keys, { key = "_", mods = super, action = "DecreaseFontSize" })
  table.insert(M.config.keys, { key = "+", mods = super, action = "IncreaseFontSize" })
else
  -- fonts, no SHIFT, use regular key value
  table.insert(M.config.keys, { key = "-", mods = super, action = "DecreaseFontSize" })
  table.insert(M.config.keys, { key = "=", mods = super, action = "IncreaseFontSize" })
end

-- clipboard
table.insert(M.config.keys, { key = "c", mods = super, action = act({ CopyTo = "Clipboard" }) })
table.insert(M.config.keys, { key = "v", mods = super, action = act({ PasteFrom = "Clipboard" }) })

return M
