return {
  'echasnovski/mini.starter',
  version = false,
  config = function()
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
            require('fzf-lua.providers.files').files({})
          end
        },
        {
          section = "",
          name = "Git Files",
          action = function()
            require('fzf-lua.providers.git').files({})
          end
        },
        {
          section = "",
          name = "Git Branches",
          action = function()
            require('fzf-lua.providers.git').branches({})
          end
        },
        {
          section = "",
          name = "Git Commits",
          action = function()
            require('fzf-lua.providers.git').commits({})
          end
        },
        {
          section = "",
          name = "Live Grep",
          action = function()
            require('fzf-lua.providers.grep').live_grep({})
          end
        },
      },
      footer = ""
    })
  end
}
