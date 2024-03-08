local M = {}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "solid",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "solid",
    pad_top = 0,
    pad_bottom = 0
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "solid",
    pad_top = 0,
    pad_bottom = 0
  })
end

local lsp_state = {}

local function lsp_highlight_document(client, bufnr)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider and not lsp_state[bufnr].highlight then
    lsp_state[bufnr].highlight = true
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", {})
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references
    })
  end
  -- Maintain if buffer has formatting enabled
  if client.server_capabilities.documentFormattingProvider and not lsp_state[bufnr].formatting then
    lsp_state[bufnr].formatting = true
  end
end

local group = vim.api.nvim_create_augroup("lsp_document_format", {})

local with_desc = function(opts, desc)
  return vim.tbl_extend("force", opts, { desc = desc })
end

local function lsp_keymaps(bufnr)
  if lsp_state[bufnr] then return false end
  lsp_state[bufnr] = { keymaps = true }

  local opts = { silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, with_desc(opts, "LSP go to declaration"))
  -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, with_desc(opts, "LSP hover"))
  -- vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
  vim.keymap.set("n", "<C-k>", function() vim.lsp.buf.signature_help() end, with_desc(opts, "LSP signature help"))
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, with_desc(opts, "LSP rename"))
  -- vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>.", function() vim.lsp.buf.code_action() end, with_desc(opts, "LSP code actions"))
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev({ border = "rounded" }) end,
    with_desc(opts, "LSP go to prev diagnostic"))
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next({ border = "rounded" }) end,
    with_desc(opts, "LSP go to next diagnostic"))
  vim.keymap.set("n", "[e",
    function() vim.diagnostic.goto_prev({ border = "rounded", severity = vim.diagnostic.severity.ERROR }) end,
    with_desc(opts, "LSP go to prev error diagnostic"))
  vim.keymap.set("n", "]e",
    function() vim.diagnostic.goto_next({ border = "rounded", severity = vim.diagnostic.severity.ERROR }) end,
    with_desc(opts, "LSP go to next error diagnostic"))
  vim.keymap.set("n", "[w",
    function() vim.diagnostic.goto_prev({ border = "rounded", severity = vim.diagnostic.severity.WARN }) end,
    with_desc(opts, "LSP go to prev warning diagnostic"))
  vim.keymap.set("n", "]w",
    function() vim.diagnostic.goto_next({ border = "rounded", severity = vim.diagnostic.severity.WARN }) end,
    with_desc(opts, "LSP go to next warning diagnostic"))
  vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, with_desc(opts, "LSP open diagnostic"))
  vim.keymap.set("n", "<leader>q", function() vim.diagnostic.setloclist() end,
    with_desc(opts, "LSP set in location list"))
  vim.keymap.set("n", "<leader>fi", function() vim.lsp.buf.format({ async = true }) end, with_desc(opts, "LSP format"))
  vim.keymap.set("n", "<leader>tfi", function() lsp_state[bufnr].formatting = not lsp_state[bufnr].formatting end,
    with_desc(opts, "LSP toggle formatting"))

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    buffer = bufnr,
    callback = function()
      if lsp_state[bufnr] and lsp_state[bufnr].formatting then
        pcall(vim.lsp.buf.format)
      end
    end
  })
  vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    buffer = bufnr,
    callback = function()
      lsp_state[bufnr] = nil
    end
  })
end

M.on_attach = function(client, bufnr)
  if client.name == "clangd" then
    client.server_capabilities.documentFormattingProvider = false
  end
  if client.name == "typescript-tools" then
    client.server_capabilities.documentFormattingProvider = false
  end
  if client.name == "eslint" then
    client.server_capabilities.documentFormattingProvider = true
  end
  if client.name == "powershell_es" then
    client.server_capabilities.documentFormattingProvider = false
  end

  -- if client.server_capabilities.inlayHintProvider then
  --   vim.lsp.buf.inlay_hint(bufnr, true)
  -- end

  lsp_keymaps(bufnr)
  lsp_highlight_document(client, bufnr)

  local require_ok, customization = pcall(require, "user.plugins.config.lsp.customization." .. client.name)
  if require_ok then
    customization.on_attach(client, bufnr)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  return
end

M.capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())

return M
