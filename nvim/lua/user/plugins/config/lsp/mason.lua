local mason = require('mason')
local masonlspconfig = require('mason-lspconfig')

local servers = {
  'clangd',
  'lua_ls',
  'pyright',
  'ruff',
  'harper_ls',
  'jsonls',
  'vtsls',
  'eslint',
  'gopls',
  'yamlls',
  'cssls',
  'ansiblels',
  'bashls',
  'powershell_es',
  'dockerls',
  'zls',
  'rust_analyzer',
  'gh_actions_ls',
  'jdtls',
  'sqlls',
  'lemminx',
  'docker_compose_language_service',
}

mason.setup({
  ui = {
    border = 'none',
    icons = {
      package_installed = '◍',
      package_pending = '◍',
      package_uninstalled = '◍',
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
})
masonlspconfig.setup({
  ensure_installed = servers,
  automatic_enable = false,
})

local lspconfig_status_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_status_ok then
  return
end

local configs = require('lspconfig.configs')
local custom_servers = { 'cfn_lsp' }

for _, server in pairs(custom_servers) do
  configs[server] = require('user.plugins.config.lsp.servers.' .. server)
end

local lsp_handlers = require('user.plugins.config.lsp.handlers')
local on_attach = lsp_handlers.on_attach
local capabilities = lsp_handlers.capabilities

local setup_server = function(server_name)
  local server = vim.split(server_name, '@')[1]
  local server_opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  local require_ok, conf_opts = pcall(require, 'user.plugins.config.lsp.settings.' .. server)
  if require_ok then
    server_opts = vim.tbl_deep_extend('force', server_opts, conf_opts)
  end

  if server == 'jdtls' then
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = function()
        require('jdtls').start_or_attach(server_opts)
      end,
    })
  else
    pcall(lspconfig[server].setup, server_opts)
  end
end

for _, server in pairs(custom_servers) do
  pcall(setup_server, server)
end

for _, server in pairs(servers) do
  pcall(setup_server, server)
end

for _, server in pairs({ 'kulala_ls' }) do
  pcall(setup_server, server)
end
