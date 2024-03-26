---@type LazyPluginSpec
return {
  'codethread/qmk.nvim',
  ---@type qmk.UserConfig
  opts = {
    name = 'LAYOUT_65_ansi_blocker',
    variant = 'qmk',
    comment_preview = {
      keymap_overrides = {}
    },
    layout = {
      'x x x x x x x x x x x x x x x',
      'x x x x x x x x x x x x x x x',
      'x x x x x x x x x x x x^x x x',
      'x x x x x x x x x x x x^x x x',
      'x x x xxxxxx^xxxxxx x x x x x'
    }
  }
}
