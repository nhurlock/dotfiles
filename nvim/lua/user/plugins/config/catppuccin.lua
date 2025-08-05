---@type LazyPluginSpec
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  commit = '931a129463ca09c8805d564a28b3d0090e536e1d',
  priority = 1000,
  ---@type CatppuccinOptions
  opts = {
    flavour = 'macchiato',
    term_colors = false,
    transparent_background = true,
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
        indentscope_color = 'surface2',
      },
    },
    custom_highlights = function(colors)
      local color_utils = require('catppuccin.utils.colors')
      local darkerbg = color_utils.darken(color_utils.bg, 0.03, colors.mantle)

      return {
        NormalFloat = { fg = colors.text, bg = darkerbg },
        FloatBorder = { fg = colors.base, bg = darkerbg },
        FloatTitle = { fg = colors.text, bg = darkerbg },

        FloatPreviewNormal = { link = 'Normal' },
        FloatPreviewTitle = { link = 'FloatTitle' },
        FloatPreviewBorder = { link = 'FloatBorder' },

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
