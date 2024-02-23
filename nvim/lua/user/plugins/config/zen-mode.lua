local utils = require("user.utilities")

return {
  "folke/zen-mode.nvim",
  keys = utils.lazy_maps({
    { "<leader>z", function() require("zen-mode").toggle() end, "n", "Zen Mode" }
  }),
  opts = {
    window = {
      width = 180
    }
  }
}
