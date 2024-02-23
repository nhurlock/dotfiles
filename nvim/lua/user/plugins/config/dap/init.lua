local utils = require("user.utilities")

return {
  "mfussenegger/nvim-dap",
  cmd = {
    "DapContinue"
  },
  keys = utils.lazy_maps({
    { "<leader>dc",    "DapContinue",                                     "n", "DAP continue" },
    { "<leader>dl",    function() require('dap').run_last() end,          "n", "DAP run last" },
    { "<leader>dt",    "DapTerminate",                                    "n", "DAP terminate" },
    { "<leader>do",    "DapStepOver",                                     "n", "DAP step over" },
    { "<leader>di",    "DapStepInto",                                     "n", "DAP step into" },
    { "<leader>b",     "DapToggleBreakpoint",                             "n", "DAP toggle breakpoint" },
    { "<leader><C-b>", function() require('dap').clear_breakpoints() end, "n", "DAP clear breakpoints" },
    { "<leader>dui",   function() require('dapui').toggle() end,          "n", "DAP toggle UI" }
  }),
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      config = true
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      config = true
    },
    {
      "mxsdev/nvim-dap-vscode-js",
      dependencies = {
        {
          "microsoft/vscode-js-debug",
          build =
          "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && rm -rf out && mv dist out && git reset --hard"
        }
      }
    }
  },
  config = function()
    require("user.plugins.config.dap.adapters.javascript")

    -- override signs
    vim.fn.sign_define('DapBreakpointCondition',
      { text = '⭘', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpoint', { text = '⭘', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DapLogPoint', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '●', texthl = 'LspDiagnosticsError', linehl = '', numhl = '' })
  end
}
