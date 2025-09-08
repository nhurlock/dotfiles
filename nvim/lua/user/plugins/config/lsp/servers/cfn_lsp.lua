---@type vim.lsp.Config
return {
  cmd = { 'cfn-lsp-extra' },
  filetypes = { 'yaml.cloudformation', 'json.cloudformation' },
  root_markers = { '.git' },
  workspace_required = false,
}
