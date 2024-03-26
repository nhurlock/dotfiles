---@type LazyPluginSpec
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",           -- simple to use language server installer
    "williamboman/mason-lspconfig.nvim", -- simple to use language server installer
    "folke/neodev.nvim",                 -- neovim-specific lsp helpers
    "pmizio/typescript-tools.nvim",      -- javascript/typescript-specific lsp helpers
    "mfussenegger/nvim-jdtls",           -- java-specific lsp helpers
  },
  config = function()
    require("neodev").setup()
    require("lspconfig")
    require("user.plugins.config.lsp.mason")
    require("user.plugins.config.lsp.handlers").setup()
  end
}
