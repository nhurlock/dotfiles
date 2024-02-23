local M = {}

M.on_attach = function(client, bufnr)
  pcall(vim.lsp.codelens.refresh)

  vim.api.nvim_create_autocmd("BufWritePost", {
    buffer = bufnr,
    callback = function()
      pcall(vim.lsp.codelens.refresh)
    end,
  })
end

return M
