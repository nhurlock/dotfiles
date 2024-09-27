local utils = require("user.utilities")

---@type LazyPluginSpec[]
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    keys = utils.lazy_maps({
      { "<M-Space>", function()
        local suggestion = require("copilot.suggestion")
        if suggestion.is_visible() then
          suggestion.dismiss()
          vim.cmd("Copilot disable")
        else
          vim.cmd("Copilot enable")
          vim.cmd("Copilot suggestion")
        end
      end, "i", "Copilot suggestion" },
    }),
    ---@type copilot_config
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = false,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = "<M-L>",
          next = "<M-J>",
          prev = "<M-K>",
          dismiss = "<M-h>",
        },
      }
    }
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    config = true
  },
}
