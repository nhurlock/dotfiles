---@module 'markview'

---@type LazyPluginSpec
return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
  ---@type mkv.config
  opts = {
    preview = {
      modes = { 'n', 'i' },
      icon_provider = 'mini',
      linewise_hybrid_mode = true,
      hybrid_modes = { 'n', 'i' },
      filetypes = { 'markdown', 'copilot-chat', 'Avante' },
    },
  },
}
