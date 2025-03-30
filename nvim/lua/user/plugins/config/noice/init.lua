local utils = require('user.utilities')

---@type LazyPluginSpec
return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  keys = utils.lazy_maps({
    { '<leader>nl', 'Noice last', 'n', 'Noice show last' },
    { '<leader>nh', 'Noice history', 'n', 'Noice view history' },
    { '<leader>nd', 'Noice dismiss', 'n', 'Noice dismiss all' },
  }),
  dependencies = {
    'MunifTanjim/nui.nvim',
    'folke/snacks.nvim',
  },
  ---@type NoiceConfig
  opts = {
    messages = {
      view = 'fidget',
    },
    redirect = {
      view = 'fidget',
    },
    notify = {
      view = 'fidget',
    },
    cmdline = {
      view = 'cmdline',
      format = {
        search_down = { kind = 'search', pattern = '^/', icon = '  ', lang = 'regex' },
        search_up = { kind = 'search', pattern = '^%?', icon = '  ', lang = 'regex' },
        cmdline = { pattern = '^:', icon = ' ', lang = 'vim' },
        filter = { pattern = '^:%s*!', icon = ' $', lang = 'bash' },
        lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = ' ', lang = 'lua' },
      },
    },
    routes = {
      {
        filter = {
          event = 'msg_show',
          any = {
            { find = '%d+L, %d+B' },
            { find = '; after #%d+' },
            { find = '; before #%d+' },
          },
        },
        view = 'fidget',
        opts = {
          timeout = 500,
        },
      },
    },
    popupmenu = {
      enabled = false,
    },
    lsp = {
      hover = {
        enabled = false,
      },
      signature = {
        enabled = false,
      },
      progress = {
        enabled = false,
      },
    },
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  },
  config = function(_, opts)
    require('user.plugins.config.noice.backends.fidget')
    require('noice').setup(opts)
  end,
}
