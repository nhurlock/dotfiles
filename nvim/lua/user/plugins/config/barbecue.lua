---@type LazyPluginSpec
return {
  "utilyre/barbecue.nvim",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  ---@type barbecue.Config
  opts = {
    theme = "catppuccin-macchiato",
    show_modified = true,
    exclude_filetypes = { "ministarter", "toggleterm", "netrw" }
  }
}
