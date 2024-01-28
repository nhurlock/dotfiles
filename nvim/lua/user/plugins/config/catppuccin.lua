return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      flavour = "macchiato",
      term_colors = true,
      dim_inactive = {
        enabled = false
      },
      integrations = {
        barbecue = {
          dim_dirname = true
        },
        gitsigns = true,
        mason = true,
        markdown = true,
        cmp = true,
        dap = true,
        dap_ui = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false
        },
        native_lsp = {
          enabled = true
        },
        noice = true,
        notify = true,
        treesitter = true,
        treesitter_context = true,
        telescope = {
          enabled = true
        },
        mini = true
      }
    })
    vim.cmd([[colorscheme catppuccin]])
  end,
}
