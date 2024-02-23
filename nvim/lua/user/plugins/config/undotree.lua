local utils = require("user.utilities")

return {
  "mbbill/undotree",
  keys = utils.lazy_maps({
    { "<leader>u", "UndotreeToggle", "n", "Undotree toggle" }
  }),
  cmd = "UndotreeToggle",
  config = function()
    vim.g.undotree_WindowLayout = 3
    vim.g.undotree_ShortIndicators = 1
  end
}
