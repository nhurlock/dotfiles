local util = require('lspconfig.util')

return {
  ---@type lspconfig.Config
  default_config = {
    -- enabled = vim.g.ai_provider == 'copilot',
    enabled = false, -- 'working', but not getting completions, disabled for now
    root_dir = util.root_pattern('.git'),
    cmd = {
      vim.fn.stdpath("data") .. '/mason/packages/copilot-language-server/node_modules/@github/copilot-language-server/native/darwin-arm64/copilot-language-server',
      '--stdio',
    },
    single_file_support = true,
    settings = {
      telemetry = {
        telemetryLevel = 'off',
      },
    },
    init_options = {
      editorInfo = {
        name = 'Neovim',
        version = '0.11.0',
      },
      editorPluginInfo = {
        name = 'GitHub Copilot for Neovim',
        version = '1.0.0',
      },
    },
  },
  docs = {
    description = [[
      GitHub Copilot LSP: https://github.com/github/copilot-language-server-release
    ]],
  },
}
