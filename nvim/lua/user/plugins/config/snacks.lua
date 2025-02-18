local utils = require("user.utilities")

---@type LazyPluginSpec
return {
  "folke/snacks.nvim",
  keys = utils.lazy_maps({
    { "<leader>go", function() Snacks.gitbrowse.open() end, "n", "Git browse open" },
    { "<leader>z",  function() Snacks.zen() end,            "n", "Zen mode" },
    { "<leader>i",  function() Snacks.image.hover() end,    "n", "Show image at cursor" }
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
    image = {
      enabled = true,
      doc = {
        enabled = true,
        inline = true,
        float = false
      }
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
