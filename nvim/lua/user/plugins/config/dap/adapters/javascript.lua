local dap = require('dap')
local dap_utils = require('dap.utils')

require('dap-vscode-js').setup({
  debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug',
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
})

for _, language in ipairs({ 'typescript', 'javascript' }) do
  dap.configurations[language] = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      cwd = '${workspaceFolder}',
    },
    {
      type = 'pwa-node',
      request = 'attach',
      name = 'Attach',
      processId = dap_utils.pick_process,
      cwd = '${workspaceFolder}',
    },
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Debug Jest Tests',
      runtimeExecutable = 'node',
      runtimeArgs = {
        './node_modules/.bin/jest',
        '--runInBand',
      },
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
      console = 'integratedTerminal',
      internalConsoleOptions = 'neverOpen',
    },
  }
end
