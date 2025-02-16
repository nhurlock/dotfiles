local utils = require("user.utilities")

---@type LazyPluginSpec
return {
  "folke/snacks.nvim",
  keys = utils.lazy_maps({
    { "<leader>go", function() Snacks.gitbrowse.open() end, "n", "Git browse open" },
    { "<leader>z",  function() Snacks.zen() end,            "n", "Zen Mode" }
  }),
  ---@type snacks.Config
  opts = {
    styles = {
      input = {
        title_pos = "left",
        relative = "cursor",
        row = -3,
        col = 0,
      }
    },
    rename = { enabled = true },
    gitbrowse = { enabled = true },
    input = {
      enabled = true,
      prompt_pos = "left",
    },
    zen = {
      enabled = true,
      toggles = { dim = false },
      win = {
        width = 180,
        backdrop = {
          transparent = false
        }
      }
    }
  },
  config = function(_, opts)
    require('snacks').setup(opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionRename",
      callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
      end,
    })
  end
}
