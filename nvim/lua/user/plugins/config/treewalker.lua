local utils = require('user.utilities')

---@type LazyPluginSpec
return {
  'aaronik/treewalker.nvim',
  keys = utils.lazy_maps({
    { '<C-k>', 'Treewalker Up', { 'n', 'v' }, 'Treewalker Up' },
    { '<C-j>', 'Treewalker Down', { 'n', 'v' }, 'Treewalker Down' },
    { '<C-h>', 'Treewalker Left', { 'n', 'v' }, 'Treewalker Left' },
    { '<C-l>', 'Treewalker Right', { 'n', 'v' }, 'Treewalker Right' },
    { '<C-S-k>', 'Treewalker SwapUp', 'n', 'Treewalker SwapUp' },
    { '<C-S-j>', 'Treewalker SwapDown', 'n', 'Treewalker SwapDown' },
    { '<C-S-h>', 'Treewalker SwapLeft', 'n', 'Treewalker SwapLeft' },
    { '<C-S-l>', 'Treewalker SwapRight', 'n', 'Treewalker SwapRight' },
  }),
  opts = {
    select = true,
    highlight = true,
    highlight_duration = 250,
    highlight_group = 'Search',
    jumplist = true,
  },
}
