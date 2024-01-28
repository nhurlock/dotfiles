return {
  "stevearc/dressing.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim"
  },
  event = "BufWinEnter",
  opts = {
    input = {
      relative = "cursor",
      win_options = {
        winblend = 0
      }
    },
    select = {
      get_config = function(opts)
        if opts.kind == 'codeaction' then
          return {
            telescope = require("telescope.themes").get_cursor({
              prompt_title = ""
            })
          }
        end
      end
    }
  }
}
