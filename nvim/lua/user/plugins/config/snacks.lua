local utils = require("user.utilities")

---@type LazyPluginSpec
return {
  "folke/snacks.nvim",
  keys = utils.lazy_maps({
    { "<leader>go", function() Snacks.gitbrowse.open() end, "n", "Git browse open" }
  }),
  opts = {
    rename = { enabled = true },
    gitbrowse = { enabled = true }
  }
}
