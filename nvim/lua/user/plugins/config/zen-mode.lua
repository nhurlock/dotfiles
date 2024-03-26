local utils = require("user.utilities")

---@type LazyPluginSpec
return {
  "folke/zen-mode.nvim",
  keys = utils.lazy_maps({
    { "<leader>z", function() require("zen-mode").toggle() end, "n", "Zen Mode" }
  }),
  ---@type ZenOptions
  opts = {
    window = {
      width = 180
    }
  }
}
