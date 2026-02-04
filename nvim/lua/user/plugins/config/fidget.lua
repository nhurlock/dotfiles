---@type LazyPluginSpec
return {
  'j-hui/fidget.nvim',
  opts = {
    notification = {
      override_vim_notify = true,
      window = {
        x_padding = 0,
        y_padding = 0,
        winblend = 0,
      },
    },
  },
}
