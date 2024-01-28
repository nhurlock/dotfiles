return {
  "mfussenegger/nvim-dap",
  cmd = {
    "DapContinue"
  },
  keys = {
    { "<leader>dc",    "<cmd>DapContinue<cr>",                            mode = { "n" }, silent = true, noremap = true, desc = "DAP continue" },
    { "<leader>dl",    "<cmd>lua require('dap').run_last()<cr>",          mode = { "n" }, silent = true, noremap = true, desc = "DAP run last" },
    { "<leader>dt",    "<cmd>DapTerminate<cr>",                           mode = { "n" }, silent = true, noremap = true, desc = "DAP terminate" },
    { "<leader>do",    "<cmd>DapStepOver<cr>",                            mode = { "n" }, silent = true, noremap = true, desc = "DAP step over" },
    { "<leader>di",    "<cmd>DapStepInto<cr>",                            mode = { "n" }, silent = true, noremap = true, desc = "DAP step into" },
    { "<leader>b",     "<cmd>DapToggleBreakpoint<cr>",                    mode = { "n" }, silent = true, noremap = true, desc = "DAP toggle breakpoint" },
    { "<leader><C-b>", "<cmd>lua require('dap').clear_breakpoints()<cr>", mode = { "n" }, silent = true, noremap = true, desc = "DAP clear breakpoints" },
    { "<leader>dui",   "<cmd>lua require('dapui').toggle()<cr>",          mode = { "n" }, silent = true, noremap = true, desc = "DAP toggle UI" }
  },
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
