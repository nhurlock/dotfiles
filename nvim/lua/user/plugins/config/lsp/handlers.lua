local methods = vim.lsp.protocol.Methods
local severity = vim.diagnostic.severity
local capabilities = vim.lsp.protocol.make_client_capabilities()
local formatting_group = vim.api.nvim_create_augroup("lsp_document_format", {})
local highlight_group = vim.api.nvim_create_augroup("lsp_document_highlight", {})
local inlay_hints_group = vim.api.nvim_create_augroup("lsp_inlay_hints", {})
local lsp_state = {}

local M = {}

---@param bufnr number | nil
local bufnr_keymap = function(bufnr)
  return function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
  end
end

---@param client vim.lsp.Client
---@param bufnr number
local function lsp_attach(client, bufnr)
  if not bufnr then return end
  if not lsp_state[bufnr] then
    lsp_state[bufnr] = { highlight = false, formatting = false, inlay_hints = false, navic = false }
  end
  local keymap = bufnr_keymap(bufnr)

  if client:supports_method(methods.textDocument_documentHighlight) and not lsp_state[bufnr].highlight then
    lsp_state[bufnr].highlight = true

    vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
      group = highlight_group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
      group = highlight_group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references
    })
  end

  if client:supports_method(methods.textDocument_formatting) and not lsp_state[bufnr].formatting then
    lsp_state[bufnr].formatting = true

    keymap("<leader>fi", function() vim.lsp.buf.format({ async = true }) end, "LSP format")
    keymap("<leader>tfi", function() lsp_state[bufnr].formatting = not lsp_state[bufnr].formatting end,
      "LSP toggle formatting")

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = formatting_group,
      buffer = bufnr,
      callback = function()
        if lsp_state[bufnr] and lsp_state[bufnr].formatting then
          pcall(vim.lsp.buf.format)
        end
      end
    })
  end

  if client:supports_method(methods.textDocument_documentSymbol) and not lsp_state[bufnr].navic then
    lsp_state[bufnr].navic = true
    require("nvim-navic").attach(client, bufnr)
  end

  if client:supports_method(methods.textDocument_declaration) then
    keymap("gD", function() vim.lsp.buf.declaration() end, "LSP go to declaration")
  end

  if client:supports_method(methods.textDocument_hover) then
    keymap("K", function() vim.lsp.buf.hover() end, "LSP hover")
  end

  if client:supports_method(methods.textDocument_signatureHelp) then
    keymap("<C-k>", function() vim.lsp.buf.signature_help() end, "LSP signature help")
  end

  if client:supports_method(methods.textDocument_rename) then
    keymap("<leader>rn", function() vim.lsp.buf.rename() end, "LSP rename")
  end

  if client:supports_method(methods.textDocument_codeAction) then
    keymap("<leader>.", function() vim.lsp.buf.code_action() end, "LSP code actions")
  end

  if client:supports_method(methods.textDocument_inlayHint) then
    vim.lsp.inlay_hint.enable(lsp_state[bufnr].inlay_hints, { bufnr = bufnr })

    keymap("<leader>tih", function()
      lsp_state[bufnr].inlay_hints = not lsp_state[bufnr].inlay_hints
      if lsp_state[bufnr].inlay_hints then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        vim.api.nvim_create_autocmd('InsertEnter', {
          group = inlay_hints_group,
          buffer = bufnr,
          callback = function()
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
          end,
        })
        vim.api.nvim_create_autocmd('InsertLeave', {
          group = inlay_hints_group,
          buffer = bufnr,
          callback = function()
            vim.lsp.inlay_hint.enable(lsp_state[bufnr].inlay_hints, { bufnr = bufnr })
          end,
        })
      else
        vim.api.nvim_clear_autocmds({ group = inlay_hints_group, buffer = bufnr })
        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
      end
    end, "LSP toggle inlay hints")
  end

  vim.api.nvim_create_autocmd("BufDelete", {
    buffer = bufnr,
    callback = function()
      lsp_state[bufnr] = nil
    end
  })
end

M.setup = function()
  vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "solid",
      source = true,
      header = "",
      prefix = "",
    },
    signs = {
      text = {
        [severity.ERROR] = '',
        [severity.WARN] = '',
        -- [severity.HINT] = '',
        [severity.HINT] = '',
        -- [severity.INFO] = ''
        [severity.INFO] = ''
      }
    }
  })

  local keymap = bufnr_keymap(nil)
  keymap("gl", function() vim.diagnostic.open_float({ focusable = true }) end, "Open diagnostic")
  keymap("<leader>q", function() vim.diagnostic.setloclist() end, "Set in location list")
  keymap("[d", function() vim.diagnostic.jump({ count = -1, border = "rounded" }) end, "Go to prev diagnostic")
  keymap("]d", function() vim.diagnostic.jump({ count = 1, border = "rounded" }) end, "Go to next diagnostic")
  keymap("[e", function() vim.diagnostic.jump({ count = -1, border = "rounded", severity = severity.ERROR }) end,
    "Go to prev error diagnostic")
  keymap("]e", function() vim.diagnostic.jump({ count = 1, border = "rounded", severity = severity.ERROR }) end,
    "Go to next error diagnostic")
  keymap("[w", function() vim.diagnostic.jump({ count = -1, border = "rounded", severity = severity.WARN }) end,
    "Go to prev warning diagnostic")
  keymap("]w", function() vim.diagnostic.jump({ count = 1, border = "rounded", severity = severity.WARN }) end,
    "Go to next warning diagnostic")


  vim.lsp.handlers[methods.textDocument_hover] = vim.lsp.buf.hover({
    border = "solid",
    pad_top = 0,
    pad_bottom = 0
  })

  vim.lsp.handlers[methods.textDocument_signatureHelp] = vim.lsp.buf.signature_help({
    border = "solid",
    pad_top = 0,
    pad_bottom = 0
  })

  local orig_reg_cap = vim.lsp.handlers[methods.client_registerCapability]
  ---@type lsp.Handler
  vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client ~= nil then M.on_attach(client, ctx.bufnr) end
    return orig_reg_cap(err, res, ctx)
  end
end

---@param client vim.lsp.Client
---@param bufnr number
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

  lsp_attach(client, bufnr)

  local require_ok, customization = pcall(require, "user.plugins.config.lsp.customization." .. client.name)
  if require_ok then
    customization.on_attach(client, bufnr)
  end
end

M.capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

return M
