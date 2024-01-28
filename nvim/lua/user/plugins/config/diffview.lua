return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory"
  },
  keys = {
    { "<leader>gv", "<cmd>DiffviewOpen<cr>",        mode = { "n" }, silent = true, noremap = true, desc = "Git open diff" },
    { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", mode = { "n" }, silent = true, noremap = true, desc = "Git file history" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  config = function()
    local actions = require("diffview.actions")
    require('diffview').setup({
      enhanced_diff_hl = true,
      hooks = {
        view_opened = function()
          actions.toggle_files()
        end
      }
    })
  end
}
