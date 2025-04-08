---@module 'markview'

---@type LazyPluginSpec
return {
  'OXY2DEV/markview.nvim',
  ---@type mkv.config
  opts = {
    preview = {
      modes = { 'n', 'i' },
      icon_provider = 'mini',
      linewise_hybrid_mode = true,
      hybrid_modes = { 'n', 'i' },
      filetypes = { 'markdown', 'copilot-chat', 'Avante', 'codecompanion' },
    },
  },
}
