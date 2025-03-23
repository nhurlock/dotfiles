local utils = require('user.utilities')
local formatting_group = vim.api.nvim_create_augroup('lsp_document_format', {})
local formatting_state = {}

---@type LazyPluginSpec
return {
  'stevearc/conform.nvim',
  opts = {
    notify_on_error = false,
    notify_no_formatters = false,
    formatters = {
      kulala = {
        command = 'kulala-fmt',
        args = { 'format', '$FILENAME' },
        stdin = false,
      },
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      http = { 'kulala' },
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = formatting_group,
      callback = function()
        local bufnr = vim.fn.bufnr()
        if formatting_state[bufnr] ~= false then
          pcall(require('conform').format, { lsp_format = 'fallback' })
        end
      end,
    })
  end,
  keys = utils.lazy_maps({
    {
      '<leader>fi',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end,
      'n',
      'LSP format',
    },
    {
      '<leader>tfi',
      function()
        local bufnr = vim.fn.bufnr()
        formatting_state[bufnr] = not formatting_state[bufnr]
      end,
      'n',
      'LSP toggle formatting',
    },
  }),
}
