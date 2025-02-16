---@type LazyPluginSpec
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  ---@type CatppuccinOptions
  opts = {
    flavour = "macchiato",
    term_colors = true,
    dim_inactive = {
      enabled = false
    },
    integrations = {
      blink_cmp = false,
      barbecue = {
        dim_dirname = true
      },
      gitsigns = true,
      mason = true,
      markdown = true,
      cmp = true,
      dap = true,
      dap_ui = true,
      diffview = true,
      fidget = true,
      fzf = true,
      native_lsp = {
        enabled = true
      },
      noice = true,
      semantic_tokens = true,
      snacks = true,
      treesitter = true,
      treesitter_context = true,
      mini = {
        enabled = true
      }
    }
  },
  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme('catppuccin')
  end,
}
