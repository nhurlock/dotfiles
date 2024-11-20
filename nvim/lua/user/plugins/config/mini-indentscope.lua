---@type LazyPluginSpec
return {
  "echasnovski/mini.indentscope",
  version = false,
  config = function()
    require("mini.indentscope").setup({
      draw = {
        animation = require("mini.indentscope").gen_animation.none()
      },
      symbol = "│"
    })

    local palette = require("catppuccin.palettes").get_palette()
    vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = palette.surface2, nocombine = true, force = true })
  end
}
