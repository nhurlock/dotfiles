local utils = require("user.utilities")

return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory"
  },
  keys = utils.lazy_maps({
    { "<leader>gv", "DiffviewOpen",        "n", "Git open diff" },
    { "<leader>gh", "DiffviewFileHistory", "n", "Git file history" },
  }),
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
