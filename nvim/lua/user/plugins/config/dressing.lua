return {
  "stevearc/dressing.nvim",
  dependencies = {
    "ibhagwan/fzf-lua",
  },
  event = "BufWinEnter",
  opts = {
    input = {
      relative = "cursor",
      win_options = {
        winblend = 0
      }
    }
  }
}
