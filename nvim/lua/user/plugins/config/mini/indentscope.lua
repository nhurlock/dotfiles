---@type LazyPluginSpec
return {
  'nvim-mini/mini.indentscope',
  version = false,
  opts = function()
    return {
      draw = {
        animation = require('mini.indentscope').gen_animation.none(),
      },
      symbol = '│',
    }
  end,
}
