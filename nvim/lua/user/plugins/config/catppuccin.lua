---@type LazyPluginSpec
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  ---@type CatppuccinOptions
  opts = {
    flavour = 'macchiato',
    term_colors = false,
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

    local palette = require('catppuccin.palettes').get_palette()
    local colors = require('catppuccin.utils.colors')

    local darkerbg = colors.darken(colors.bg, 0.03, palette.mantle)

    vim.api.nvim_set_hl(0, 'NormalFloat', { fg = palette.text, bg = darkerbg, force = true })
    vim.api.nvim_set_hl(0, 'FloatBorder', { fg = palette.base, bg = darkerbg, force = true })
    vim.api.nvim_set_hl(0, 'FloatTitle', { fg = palette.text, bg = darkerbg, force = true })

    vim.api.nvim_set_hl(0, 'FloatPreviewNormal', { link = 'Normal', force = true })
    vim.api.nvim_set_hl(0, 'FloatPreviewTitle', { link = 'FloatTitle', force = true })
    vim.api.nvim_set_hl(0, 'FloatPreviewBorder', { link = 'FloatBorder', force = true })
  end,
}
