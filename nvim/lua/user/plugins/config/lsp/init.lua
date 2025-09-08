---@type LazyPluginSpec
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    {
      'folke/lazydev.nvim', -- lua-specific lsp helpers
      ft = 'lua',
      dependencies = {
        { 'Bilal2453/luvit-meta', lazy = true },
      },
      opts = {
        library = {
          { path = 'luvit-meta/library', words = { 'vim%.uv' } },
          { path = 'lazy.nvim', words = { 'Lazy' } },
        },
      },
    },
    'mfussenegger/nvim-jdtls', -- java-specific lsp helpers
  },
  config = function()
    require('user.plugins.config.lsp.mason')
    require('user.plugins.config.lsp.handlers').setup()
  end,
}
