local util = require('lspconfig.util')

return {
  default_config = {
    cmd = { 'cfn-lsp-extra' },
    filetypes = { 'yaml.cloudformation', 'json.cloudformation' },
    root_dir = util.root_pattern('.git'),
    single_file_support = true
  },
  docs = {
    description = [[
      Cloudformation LSP: https://github.com/LaurenceWarne/cfn-lsp-extra
    ]]
  }
}
