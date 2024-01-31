return {
  "folke/zen-mode.nvim",
  keys = {
    {
      "<leader>z",
      function()
        require("zen-mode").toggle()
      end,
      mode = { "n" },
      silent = true,
      noremap = true,
      desc = "Zen Mode"
    }
  },
  opts = {
    window = {
      width = 180
    }
  }
}
