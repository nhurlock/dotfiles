local utils = require('user.utilities')

---@type LazyPluginSpec
return {
  'nvzone/typr',
  dependencies = 'nvzone/volt',
  cmd = { 'Typr', 'TyprStats' },
  keys = utils.lazy_maps({
    { '<leader>tyy', 'Typr', 'n', desc = 'Typr' },
    { '<leader>tys', 'TyprStats', 'n', desc = 'Typr' },
  }),
  config = true,
}
