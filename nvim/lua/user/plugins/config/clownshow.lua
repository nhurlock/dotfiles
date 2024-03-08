local utils = require("user.utilities")

return {
  "nhurlock/clownshow.nvim",
  dev = false,
  -- cmd = "JestWatch",
  event = {
    "BufEnter *.test.[tj]s",
    "BufEnter *.spec.[tj]s"
  },
  keys = utils.lazy_maps({
    { "<leader>tt", "JestWatchToggle",    "n", "Toggle Jest watch" },
    { "<leader>tl", "JestWatchLogToggle", "n", "Toggle Jest watch log view" },
  }),
  config = true
}
