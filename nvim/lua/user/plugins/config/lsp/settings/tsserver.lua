local customization = require('user.plugins.config.lsp.customization.tsserver')

return {
  cmd = { "bunx", "typescript-language-server", "--stdio" },
  handlers = customization.handlers,
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true
      }
    }
  },
  init_options = {
    tsserver = {
      path = './node_modules/typescript/lib/tsserver.js'
    },
    preferences = {
      includeCompletionsForModuleExports = true,
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = false,
      includeInlayPropertyDeclarationTypeHints = false,
      includeInlayFunctionLikeReturnTypeHints = false,
      includeInlayEnumMemberValueHints = true
    }
  }
}
