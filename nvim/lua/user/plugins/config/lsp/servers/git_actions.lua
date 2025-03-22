local util = require('lspconfig.util')

local this_file_dir = debug.getinfo(1, 'S').source:match('@(.*/)') or ''

return {
  ---@type lspconfig.Config
  default_config = {
    cmd = { 'node', this_file_dir .. '/git_actions/dist/server.mjs', '--stdio' },
    filetypes = { 'yaml.git_actions' },
    root_dir = util.root_pattern('.github'),
    single_file_support = true,
  },
  docs = {
    description = [[
      Github Actions LSP: https://github.com/actions/languageservices/tree/main/languageserver
    ]],
  },
  settings = {
    documentSelector = {
      {
        pattern = '**/.github/workflows/*.{yaml,yml}',
      },
    },
  },
}
