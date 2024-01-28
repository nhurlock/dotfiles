vim.cmd [[highlight IndentBlanklineContextChar1 guifg=#555555 gui=nocombine]]

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = " ",
      tab_char = " "
    },
    whitespace = {},
    scope = {
      char = "│",
      show_start = false,
      show_end = false,
      highlight = { "IndentBlanklineContextChar1" }
    }
  }
}
