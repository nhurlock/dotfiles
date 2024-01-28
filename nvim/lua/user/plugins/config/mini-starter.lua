return {
  'echasnovski/mini.starter',
  version = false,
  config = function()
    local telescope_builtin = require('telescope.builtin')

    require('mini.starter').setup({
      autoopen = true,
      silent = true,
      header = function()
        return vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      end,
      items = {
        {
          section = "",
          name = "File Browser",
          action = function()
            require("neo-tree.command").execute({ action = "focus" })
          end
        },
        {
          section = "",
          name = "Find Files",
          action = function()
            telescope_builtin.find_files({})
          end
        },
        {
          section = "",
          name = "Git Files",
          action = function()
            telescope_builtin.git_files({})
          end
        },
        {
          section = "",
          name = "Git Branches",
          action = function()
            telescope_builtin.git_branches({})
          end
        },
        {
          section = "",
          name = "Git Commits",
          action = function()
            telescope_builtin.git_commits({})
          end
        },
        {
          section = "",
          name = "Live Grep",
          action = function()
            telescope_builtin.live_grep({})
          end
        },
      },
      footer = ""
    })
  end
}
