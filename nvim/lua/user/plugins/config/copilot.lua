local utils = require("user.utilities")

---@type LazyPluginSpec[]
return {
  {
    "zbirenbaum/copilot.lua",
    enabled = vim.env.USER ~= "nhurlock",
    cmd = "Copilot",
    event = "InsertEnter",
    keys = utils.lazy_maps({
      { "<M-Space>", function()
        local copilot = require('copilot.client')
        local suggestion = require("copilot.suggestion")
        if copilot.is_disabled() then
          vim.cmd("Copilot enable")
          vim.cmd("Copilot suggestion")
          vim.b.copilot_suggestion_auto_trigger = true
        else
          if suggestion.is_visible() then
            suggestion.dismiss()
          end
          vim.cmd("Copilot disable")
          vim.b.copilot_suggestion_auto_trigger = false
        end
      end, { "n", "i" }, "Copilot toggle" },
    }),
    ---@type copilot_config
    opts = {
      filetypes = {
        ['yaml.git_actions'] = true,
        ['yaml.cloudformation'] = true
      },
      suggestion = {
        enabled = false,
        auto_trigger = false,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = "<M-L>",
          next = "<M-J>",
          prev = "<M-K>",
          dismiss = false,
        },
      }
    }
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = vim.env.USER ~= "nhurlock",
    branch = "canary",
    config = true
  },
}
