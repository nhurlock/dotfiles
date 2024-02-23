return {
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "IndentBlanklineContextChar",
        { fg = "#555555", bg = "#555555", nocombine = true, force = true })
    end)

    require('ibl').setup({
      indent = {
        char = " ",
        tab_char = " "
      },
      whitespace = {},
      scope = {
        char = "│",
        show_start = false,
        show_end = false,
        highlight = { "IndentBlanklineContextChar" }
      }
    })
  end
}
