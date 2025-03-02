---@type LazyPluginSpec
return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  ---@type mkv.config
  opts = {
    preview = {
      modes = { "n", "i" },
      hybrid_modes = { "i" },
      filetypes = { "markdown", "codecompanion", "copilot-chat", "Avante", "noice" },
      buf_ignore = {}
    }
  }
}
