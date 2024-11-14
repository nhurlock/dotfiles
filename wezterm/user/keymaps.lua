local wezterm = require("wezterm")
local colors = require("user.colors")
local env_ok, env = pcall(require, "user.env")
if not env_ok then
  env = {}
end

local act = wezterm.action

local M = {}

M.config = {}

M.config.leader = { key = "s", mods = "CTRL" }

M.config.disable_default_key_bindings = true

M.config.keys = {
  -- panes
  { key = "a",   mods = "LEADER",       action = act.ActivateKeyTable({ name = "adjust_pane", one_shot = false }) },
  { key = "h",   mods = "LEADER",       action = act.ActivatePaneDirection("Left") },
  { key = "j",   mods = "LEADER",       action = act.ActivatePaneDirection("Down") },
  { key = "k",   mods = "LEADER",       action = act.ActivatePaneDirection("Up") },
  { key = "l",   mods = "LEADER",       action = act.ActivatePaneDirection("Right") },
  { key = "H",   mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "J",   mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "K",   mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "L",   mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "x",   mods = "LEADER",       action = act.CloseCurrentPane({ confirm = true }) },
  { key = "s",   mods = "LEADER",       action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }) },
  { key = "z",   mods = "LEADER",       action = act.TogglePaneZoomState },

  -- splits
  { key = "-",   mods = "LEADER",       action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "\\",  mods = "LEADER",       action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

  -- tabs
  { key = "t",   mods = "LEADER",       action = act.ActivateKeyTable({ name = "tab_selection", one_shot = false }) },
  { key = "m",   mods = "LEADER",       action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
  { key = "c",   mods = "LEADER",       action = act.SpawnTab("CurrentPaneDomain") },
  { key = "s",   mods = "LEADER",       action = act.Search("CurrentSelectionOrEmptyString") },
  { key = "[",   mods = "LEADER",       action = act.ActivateTabRelative(-1) },
  { key = "]",   mods = "LEADER",       action = act.ActivateTabRelative(1) },
  { key = "Tab", mods = "CTRL|SHIFT",   action = act.ActivateTabRelative(-1) },
  { key = "Tab", mods = "CTRL",         action = act.ActivateTabRelative(1) },
  { key = "1",   mods = "LEADER",       action = act.ActivateTab(0) },
  { key = "2",   mods = "LEADER",       action = act.ActivateTab(1) },
  { key = "3",   mods = "LEADER",       action = act.ActivateTab(2) },
  { key = "4",   mods = "LEADER",       action = act.ActivateTab(3) },
  { key = "5",   mods = "LEADER",       action = act.ActivateTab(4) },
  { key = "6",   mods = "LEADER",       action = act.ActivateTab(5) },
  { key = "7",   mods = "LEADER",       action = act.ActivateTab(6) },
  { key = "8",   mods = "LEADER",       action = act.ActivateTab(7) },
  { key = "9",   mods = "LEADER",       action = act.ActivateTab(8) },
  -- single pane tabs can be closed just using the non-shift pane-close keymap
  { key = "x",   mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
  {
    key = "r",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { Color = colors.purple } },
        { Text = "Enter new name for tab" },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        if line ~= nil then
          window:active_tab():set_title(line)
        end
      end)
    })
  },

  -- workspaces
  { key = "f", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
  { key = "w", mods = "LEADER", action = act.ActivateKeyTable({ name = "workspace_selection", one_shot = false }) },
  {
    key = "w",
    mods = "LEADER|SHIFT",
    action = act.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { Color = colors.purple } },
        { Text = "Switch to workspace" },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        if line ~= nil then
          window:perform_action(
            act.SwitchToWorkspace({
              name = (#line > 1 and line) or "default"
            }),
            pane
          )
        end
      end)
    })
  },
  {
    key = "r",
    mods = "LEADER|SHIFT",
    action = act.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { Color = colors.purple } },
        { Text = "Enter new name for workspace" },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        if line ~= nil and #line > 1 then
          wezterm.mux.rename_workspace(window:active_workspace(), line)
        end
      end)
    })
  },

  -- modes
  { key = "C", mods = "LEADER|SHIFT", action = act.ActivateCopyMode },
  { key = "q", mods = "LEADER",       action = act.QuickSelect },
  {
    key = "U",
    mods = "LEADER|SHIFT",
    action = act.QuickSelectArgs({
      label = "open url",
      patterns = {
        "https?://\\S+",
      },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.open_with(url)
      end),
    }),
  },
  {
    key = "J",
    mods = "LEADER|SHIFT",
    action = act.QuickSelectArgs({
      label = "open jira issue",
      patterns = {
        "[A-Z]{3,10}-[0-9]{1,10}",
      },
      action = wezterm.action_callback(function(window, pane)
        if env.open_jira_issue ~= nil then
          local jira_issue = window:get_selection_text_for_pane(pane)
          env.open_jira_issue(wezterm.open_with, jira_issue)
        end
      end),
    }),
  },

  -- misc
  { key = "n", mods = "LEADER", action = act.ToggleFullScreen },
  { key = ",", mods = "LEADER", action = act.ShowDebugOverlay }
}

M.config.key_tables = {
  tab_selection = {
    { key = "h",      action = act.ActivateTabRelative(-1) },
    { key = "l",      action = act.ActivateTabRelative(1) },
    { key = "Escape", action = act.PopKeyTable }
  },
  workspace_selection = {
    { key = "h",      action = act.SwitchWorkspaceRelative(-1) },
    { key = "l",      action = act.SwitchWorkspaceRelative(1) },
    { key = "Escape", action = act.PopKeyTable }
  },
  adjust_pane = {
    { key = "h",      action = act.ActivatePaneDirection("Left") },
    { key = "j",      action = act.ActivatePaneDirection("Down") },
    { key = "k",      action = act.ActivatePaneDirection("Up") },
    { key = "l",      action = act.ActivatePaneDirection("Right") },
    { key = "h",      mods = "ALT",                                                 action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "j",      mods = "ALT",                                                 action = act.AdjustPaneSize({ "Down", 5 }) },
    { key = "k",      mods = "ALT",                                                 action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "l",      mods = "ALT",                                                 action = act.AdjustPaneSize({ "Right", 5 }) },
    { key = "S",      action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }) },
    { key = "Escape", action = act.PopKeyTable }
  },
  move_tab = {
    { key = "h",      action = act.MoveTabRelative(-1) },
    { key = "l",      action = act.MoveTabRelative(1) },
    { key = "Escape", action = act.PopKeyTable }
  },
  copy_mode = {
    { key = "w",      action = act.CopyMode("MoveForwardWord") },
    { key = "b",      action = act.CopyMode("MoveBackwardWord") },
    { key = "e",      action = act.CopyMode("MoveForwardWordEnd") },
    { key = "Enter",  action = act.CopyMode("MoveToStartOfNextLine") },
    { key = "v",      action = act.CopyMode({ SetSelectionMode = "Cell" }) },
    { key = "v",      mods = "CTRL",                                                 action = act.CopyMode({ SetSelectionMode = "Block" }) },
    { key = "V",      mods = "SHIFT",                                                action = act.CopyMode({ SetSelectionMode = "Line" }) },
    { key = "^",      mods = "SHIFT",                                                action = act.CopyMode("MoveToStartOfLineContent") },
    { key = "$",      mods = "SHIFT",                                                action = act.CopyMode("MoveToEndOfLineContent") },
    { key = ",",      action = act.CopyMode("JumpReverse") },
    { key = "0",      action = act.CopyMode("MoveToStartOfLine") },
    { key = ";",      action = act.CopyMode("JumpAgain") },
    { key = "f",      action = act.CopyMode({ JumpForward = { prev_char = false } }) },
    { key = "F",      mods = "SHIFT",                                                action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
    { key = "g",      action = act.CopyMode("MoveToScrollbackTop") },
    { key = "G",      mods = "SHIFT",                                                action = act.CopyMode("MoveToScrollbackBottom") },
    { key = "H",      mods = "SHIFT",                                                action = act.CopyMode("MoveToViewportTop") },
    { key = "L",      mods = "SHIFT",                                                action = act.CopyMode("MoveToViewportBottom") },
    { key = "M",      mods = "SHIFT",                                                action = act.CopyMode("MoveToViewportMiddle") },
    { key = "o",      action = act.CopyMode("MoveToSelectionOtherEnd") },
    { key = "t",      action = act.CopyMode({ JumpForward = { prev_char = true } }) },
    { key = "T",      mods = "SHIFT",                                                action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
    { key = "u",      mods = "CTRL",                                                 action = act.CopyMode({ MoveByPage = -0.5 }) },
    { key = "d",      mods = "CTRL",                                                 action = act.CopyMode({ MoveByPage = 0.5 }) },
    { key = "h",      action = act.CopyMode("MoveLeft") },
    { key = "j",      action = act.CopyMode("MoveDown") },
    { key = "k",      action = act.CopyMode("MoveUp") },
    { key = "l",      action = act.CopyMode("MoveRight") },
    { key = "Escape", action = act.ClearSelection },
    { key = "c",      mods = "CTRL",                                                 action = act.CopyMode("Close"), },
    { key = "q",      action = act.CopyMode("Close") },
    {
      key = "y",
      action = act.Multiple({
        { CopyTo = "ClipboardAndPrimarySelection" },
        { CopyMode = "Close" }
      })
    }
  },
}

local super = "SUPER"
if string.match(tostring(os.getenv("OS")), "Windows") then
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
