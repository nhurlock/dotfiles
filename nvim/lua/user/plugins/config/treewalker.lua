local utils = require('user.utilities')

---@type LazyPluginSpec
return {
  'aaronik/treewalker.nvim',
  keys = utils.lazy_maps({
    { '<C-k>', 'Treewalker Up', 'n', 'Treewalker Up' },
    { '<C-j>', 'Treewalker Down', 'n', 'Treewalker Down' },
    { '<C-h>', 'Treewalker Left', 'n', 'Treewalker Left' },
    { '<C-l>', 'Treewalker Right', 'n', 'Treewalker Right' },
    { '<C-S-k>', 'Treewalker SwapUp', 'n', 'Treewalker SwapUp' },
    { '<C-S-j>', 'Treewalker SwapDown', 'n', 'Treewalker SwapDown' },
    { '<C-S-h>', 'Treewalker SwapLeft', 'n', 'Treewalker SwapLeft' },
    { '<C-S-l>', 'Treewalker SwapRight', 'n', 'Treewalker SwapRight' },
  }),
  opts = {
    highlight = true,
    highlight_duration = 250,
    highlight_group = 'Search',
    jumplist = true,
  },
}
