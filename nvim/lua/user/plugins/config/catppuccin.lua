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
    color_overrides = {
      -- botanical monkeytype theme colors
      mocha = {
        -- Using botanical colors with similar contrast to macchiato
        rosewater = '#f6c9b4', -- error color
        flamingo = '#f59a71',  -- error-alt
        pink = '#d1e2e8',      -- lighter variation of main
        mauve = '#abc6c4',     -- caret
        red = '#f59a71',       -- error-alt as accent
        maroon = '#f6c9b4',    -- error
        peach = '#c0d5d9',     -- muted variation of main
        yellow = '#eaf1f3',    -- text/main
        green = '#abc6c4',     -- caret
        teal = '#72908d',      -- sub-alt
        sky = '#9ec2be',       -- lighter variation of bg
        sapphire = '#7b9c98',  -- bg
        blue = '#8fb3af',      -- lighter bg
        lavender = '#a6c7c3',  -- even lighter bg
        text = '#eaf1f3',      -- main/text
        subtext1 = '#d6e6e8',  -- slightly darker than text
        subtext0 = '#c0d5d9',  -- more darker than text
        overlay2 = '#a6c7c3',  -- between bg and text
        overlay1 = '#8fb3af',  -- between bg and overlay2
        overlay0 = '#72908d',  -- sub-alt
        surface2 = '#5e7d79',  -- darker than sub-alt
        surface1 = '#495755',  -- sub
        surface0 = '#3a4644',  -- darker than sub
        base = '#2d3735',      -- very dark bg
        mantle = '#252d2c',    -- even darker bg
        crust = '#1d2321',     -- darkest bg
      },
      -- macchiato = {
      --   rosewater = '#f4dbd6',
      --   flamingo = '#f0c6c6',
      --   pink = '#f5bde6',
      --   mauve = '#c6a0f6',
      --   red = '#ed8796',
      --   maroon = '#ee99a0',
      --   peach = '#f5a97f',
      --   yellow = '#eed49f',
      --   green = '#a6da95',
      --   teal = '#8bd5ca',
      --   sky = '#91d7e3',
      --   sapphire = '#7dc4e4',
      --   blue = '#8aadf4',
      --   lavender = '#b7bdf8',
      --   text = '#cad3f5',
      --   subtext1 = '#b8c0e0',
      --   subtext0 = '#a5adcb',
      --   overlay2 = '#939ab7',
      --   overlay1 = '#8087a2',
      --   overlay0 = '#6e738d',
      --   surface2 = '#5b6078',
      --   surface1 = '#494d64',
      --   surface0 = '#363a4f',
      --   base = '#24273a',
      --   mantle = '#1e2030',
      --   crust = '#181926',
      -- },
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
