---@module 'qmk'

---@type LazyPluginSpec
return {
  'codethread/qmk.nvim',
  ---@type qmk.UserConfig
  opts = {
    name = 'LAYOUT',
    variant = 'qmk',
    comment_preview = {
      keymap_overrides = {},
    },
    layout = {
      'x x x x x x x _ x x x x x x x',
      'x x x x x x x _ x x x x x x x',
      'x x x x x x x _ x x x x x x x',
      'x x x x x x x _ x x x x x x x',
      '_ _ _ x x x x _ x x x x _ _ _',
    },
  },
}
