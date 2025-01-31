local utils = require("user.utilities")

---@type LazyPluginSpec
return {
  "folke/snacks.nvim",
  keys = utils.lazy_maps({
    { "<leader>go", function() Snacks.gitbrowse.open() end, "n", "Git browse open" },
    { "<leader>z",  function() Snacks.zen() end,            "n", "Zen Mode" }
  }),
  ---@type snacks.Config
  opts = {
    rename = { enabled = true },
    gitbrowse = { enabled = true },
    zen = {
      enabled = true,
      toggles = { dim = false },
      win = {
        width = 180,
        backdrop = {
          transparent = false
        }
      }
    }
  }
}
