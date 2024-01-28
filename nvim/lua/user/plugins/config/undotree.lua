return {
  "mbbill/undotree",
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<cr>", mode = { "n" }, silent = true, noremap = true, desc = "Undotree toggle" }
  },
  cmd = "UndotreeToggle",
  config = function()
    vim.g.undotree_WindowLayout = 3
    vim.g.undotree_ShortIndicators = 1
  end
}
