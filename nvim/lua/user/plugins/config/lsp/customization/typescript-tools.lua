local M = {}

M.on_attach = function(client, bufnr)
  vim.keymap.set("n", "gD", "<cmd>TSToolsGoToSourceDefinition<cr>",
    { buffer = bufnr, silent = true, desc = "Typescript go to source definition" })
end

return M
