local utils = require("user.utilities")

---@type LazyPluginSpec
return {
  "akinsho/toggleterm.nvim",
  keys = utils.lazy_maps({
    { "<leader>\\", "ToggleTerm",                     "n", "Toggle terminal" },
    { "<leader>gg", function() _LAZYGIT_TOGGLE() end, "n", "Lazygit" },
    { "<leader>no", function() _NODE_TOGGLE() end,    "n", "Node terminal" },
  }),
  cmd = "ToggleTerm",
  config = function()
    require("toggleterm").setup({
      size = 20,
      hide_numbers = true,
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = false,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      highlights = {
        Normal = { link = "Normal" },
        NormalFloat = { link = "NormalFloat" },
        FloatBorder = { link = "FloatBorder" }
      },
      float_opts = {
        border = "solid",
        winblend = 0
      }
    })

    local Terminal = require("toggleterm.terminal").Terminal

    -- create a terminal for Lazygit tui
    local lazygit = Terminal:new({
      cmd = "lazygit",
      hidden = true,
      direction = "float"
    })
    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end

    -- create a terminal for Node repl
    local node = Terminal:new({ cmd = "node", hidden = true })
    function _NODE_TOGGLE()
      node:toggle()
    end
  end
}
