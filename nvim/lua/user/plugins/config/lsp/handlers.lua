local methods = vim.lsp.protocol.Methods
local severity = vim.diagnostic.severity
local capabilities = vim.lsp.protocol.make_client_capabilities()
local highlight_group = vim.api.nvim_create_augroup('lsp_document_highlight', {})
local inlay_hints_group = vim.api.nvim_create_augroup('lsp_inlay_hints', {})
local lsp_state = {}
local lsp_popup_config = { border = 'solid', max_height = 25, max_width = 100 }

local M = {}

---@param bufnr number | nil
local bufnr_keymap = function(bufnr)
  return function(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
  end
end

---@param client vim.lsp.Client
---@param bufnr number
local function lsp_attach(client, bufnr)
  if not bufnr then
    return
  end
  if not lsp_state[bufnr] then
    lsp_state[bufnr] = { highlight = false, formatting = false, inlay_hints = false, navic = false }
  end
  local keymap = bufnr_keymap(bufnr)

  if client:supports_method(methods.textDocument_documentHighlight) and not lsp_state[bufnr].highlight then
    lsp_state[bufnr].highlight = true

    vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
      group = highlight_group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
      group = highlight_group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client:supports_method(methods.textDocument_documentSymbol) and not lsp_state[bufnr].navic then
    lsp_state[bufnr].navic = true
    require('nvim-navic').attach(client, bufnr)
  end

  if client:supports_method(methods.textDocument_declaration) then
    keymap('gD', function()
      vim.lsp.buf.declaration()
    end, 'LSP go to declaration')
  end

  if client:supports_method(methods.textDocument_hover) then
    keymap('K', function()
      vim.lsp.buf.hover(lsp_popup_config)
    end, 'LSP hover')
  end

  if client:supports_method(methods.textDocument_signatureHelp) then
    keymap('<C-k>', function()
      vim.lsp.buf.signature_help(lsp_popup_config)
    end, 'LSP signature help')
  end

  if client:supports_method(methods.textDocument_rename) then
    keymap('<leader>rn', function()
      vim.lsp.buf.rename()
    end, 'LSP rename')
  end

  if client:supports_method(methods.textDocument_codeAction) then
    keymap('<leader>.', function()
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      local code_action_kinds = {}

      -- needed to account for code actions that are not selected by default
      for _, client in ipairs(clients) do
        if type(client.server_capabilities.codeActionProvider) == 'table' then
          for _, kind in ipairs(client.server_capabilities.codeActionProvider.codeActionKinds) do
            if not vim.tbl_contains(code_action_kinds, kind) then
              table.insert(code_action_kinds, kind)
            end
          end
        end
      end

      vim.lsp.buf.code_action({ context = { only = code_action_kinds } })
    end, 'LSP code actions')
  end

  if client:supports_method(methods.textDocument_inlayHint) then
    vim.lsp.inlay_hint.enable(lsp_state[bufnr].inlay_hints, { bufnr = bufnr })

    keymap('<leader>tih', function()
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
    end, 'LSP toggle inlay hints')
  end

  vim.api.nvim_create_autocmd('BufDelete', {
    buffer = bufnr,
    callback = function()
      lsp_state[bufnr] = nil
    end,
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
      style = 'minimal',
      border = 'solid',
      source = true,
      header = '',
      prefix = '',
    },
    signs = {
      text = {
        [severity.ERROR] = '',
        [severity.WARN] = '',
        [severity.HINT] = '',
        [severity.INFO] = '',
      },
    },
  })

  local keymap = bufnr_keymap(nil)
  keymap('gl', function()
    local diagnostic_config = vim.diagnostic.config()
    if not diagnostic_config then
      return
    end
    if
      diagnostic_config.virtual_lines == nil
      or diagnostic_config.virtual_lines == false
      or diagnostic_config.virtual_lines.current_line == false
    then
      diagnostic_config.virtual_lines = { current_line = true }
      vim.diagnostic.config(diagnostic_config)
    else
      diagnostic_config.virtual_lines = false
      vim.diagnostic.config(diagnostic_config)
    end
  end, 'Toggle inline diagnostics')
  keymap('gL', function()
    vim.diagnostic.open_float({ focusable = true })
  end, 'Open diagnostic float')
  keymap('<leader>q', function()
    vim.diagnostic.setloclist()
  end, 'Set in location list')
  keymap('[e', function()
    vim.diagnostic.jump({ count = -1, severity = severity.ERROR })
  end, 'Go to prev error diagnostic')
  keymap(']e', function()
    vim.diagnostic.jump({ count = 1, severity = severity.ERROR })
  end, 'Go to next error diagnostic')
  keymap('[w', function()
    vim.diagnostic.jump({ count = -1, severity = severity.WARN })
  end, 'Go to prev warning diagnostic')
  keymap(']w', function()
    vim.diagnostic.jump({ count = 1, severity = severity.WARN })
  end, 'Go to next warning diagnostic')

  local orig_reg_cap = vim.lsp.handlers[methods.client_registerCapability]
  ---@type lsp.Handler
  vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client ~= nil then
      M.on_attach(client, ctx.bufnr)
    end
    return orig_reg_cap(err, res, ctx)
  end
end

---@param client vim.lsp.Client
---@param bufnr number
M.on_attach = function(client, bufnr)
  if client.name == 'clangd' then
    client.server_capabilities.documentFormattingProvider = false
  end
  if client.name == 'vtsls' then
    client.server_capabilities.documentFormattingProvider = false
  end
  if client.name == 'eslint' then
    client.server_capabilities.documentFormattingProvider = true
  end
  if client.name == 'powershell_es' then
    client.server_capabilities.documentFormattingProvider = false
  end

  lsp_attach(client, bufnr)

  local require_ok, customization = pcall(require, 'user.plugins.config.lsp.customization.' .. client.name)
  if require_ok then
    customization.on_attach(client, bufnr)
  end
end

M.capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

return M
