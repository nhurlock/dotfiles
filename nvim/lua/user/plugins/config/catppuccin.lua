---@type LazyPluginSpec
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  ---@type CatppuccinOptions
  opts = {
    flavour = 'macchiato',
    term_colors = true,
    dim_inactive = {
      enabled = false,
    },
    integrations = {
      blink_cmp = true,
      gitsigns = true,
      mason = true,
      markdown = true,
      dap = true,
      dap_ui = true,
      diffview = true,
      fidget = true,
      fzf = true,
      native_lsp = {
        enabled = true,
      },
      navic = {
        enabled = true,
        custom_bg = 'NONE',
      },
      noice = true,
      semantic_tokens = true,
      snacks = true,
      treesitter = true,
      treesitter_context = true,
      mini = {
        enabled = true,
      },
    },
    custom_highlights = function(colors)
      return {
        NavicText = { fg = colors.text, bg = 'NONE' },
        NavicSeparator = { fg = colors.overlay0, bg = 'NONE' },
      }
    end,
  },
  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme('catppuccin')
  end,
}
