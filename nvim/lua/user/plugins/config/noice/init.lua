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
      enabled = false,
    },
    cmdline = {
      enabled = false,
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
      message = {
        enabled = false,
      },
    },
    health = {
      checker = false,
    },
  },
  config = function(_, opts)
    require('user.plugins.config.noice.backends.fidget')
    require('noice').setup(opts)
  end,
}
