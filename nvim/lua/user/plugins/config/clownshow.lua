local utils = require('user.utilities')

---@type LazyPluginSpec
return {
  'nhurlock/clownshow.nvim',
  dev = false,
  -- cmd = "JestWatch",
  event = {
    'BufEnter *.test.[tj]s',
    'BufEnter *.spec.[tj]s',
  },
  keys = utils.lazy_maps({
    { '<leader>tt', 'JestWatchToggle', 'n', 'Toggle Jest watch' },
    { '<leader>tl', 'JestWatchLogToggle', 'n', 'Toggle Jest watch log view' },
  }),
  config = function()
    require('clownshow').setup({
      jest_command = function(opts)
        return 'node --no-warnings --experimental-vm-modules '
          .. require('clownshow.config.defaults').jest_command(opts)
      end,
    })
  end,
}
