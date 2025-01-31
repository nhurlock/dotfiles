local M = {}

M.projects = require("user.plugins.config.fzf-lua.pickers.projects")
M.fidget = require("user.plugins.config.fzf-lua.pickers.fidget")
M.jira_issues = function()
  local jira_issues_picker_ok, jira_issues_picker = pcall(require, "jira-issues.fzf.picker")
  local jira_config_ok, jira_config = pcall(require, "user.config.jira")
  if jira_config_ok and jira_issues_picker_ok then jira_issues_picker(jira_config) end
end

return M
