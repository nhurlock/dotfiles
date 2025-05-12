---@type LazyPluginSpec
return {
  'echasnovski/mini.indentscope',
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
