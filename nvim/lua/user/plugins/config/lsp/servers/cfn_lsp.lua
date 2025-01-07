local util = require('lspconfig.util')

return {
  ---@type lspconfig.Config
  default_config = {
    cmd = { 'cfn-lsp-extra' },
    filetypes = { 'yaml.cloudformation', 'json.cloudformation' },
    root_dir = util.root_pattern('.git'),
    single_file_support = true,
    settings = {
      documentFormatting = false
    }
  },
  docs = {
    description = [[
      Cloudformation LSP: https://github.com/LaurenceWarne/cfn-lsp-extra
    ]]
  }
}
