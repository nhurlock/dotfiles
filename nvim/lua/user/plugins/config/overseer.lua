local utils = require('user.utilities')

---@type LazyPluginSpec
return {
  'stevearc/overseer.nvim',
  keys = utils.lazy_maps({
    { '<leader>oo', 'OverseerToggle', 'n', 'Overseer Open' },
    { '<leader>or', 'OverseerRun', 'n', 'Overseer Run' },
  }),
  opts = {},
}
