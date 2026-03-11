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

    vim.api.nvim_create_autocmd('LspProgress', {
      callback = function(ev)
        local value = ev.data.params.value
        if value.kind == 'begin' then
          vim.api.nvim_ui_send('\027]9;4;1;0\027\\')
        elseif value.kind == 'end' then
          vim.api.nvim_ui_send('\027]9;4;0\027\\')
        elseif value.kind == 'report' then
          vim.api.nvim_ui_send(string.format('\027]9;4;1;%d\027\\', value.percentage or 0))
        end
      end,
    })
  end,
}
