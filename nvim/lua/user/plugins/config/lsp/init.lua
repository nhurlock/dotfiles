---@type LazyPluginSpec
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",           -- simple to use language server installer
    "williamboman/mason-lspconfig.nvim", -- simple to use language server installer
    {
      "folke/lazydev.nvim",              -- lua-specific lsp helpers
      ft = "lua",
      opts = {
        library = {
          vim.env.LAZY .. "/luvit-meta/library",
        },
      },
    },
    { "Bilal2453/luvit-meta",         lazy = true },               -- optional `vim.uv` typings
    { "notomo/typescript-tools.nvim", branch = "fix-deprecated" }, -- javascript/typescript-specific lsp helpers
    "mfussenegger/nvim-jdtls",                                     -- java-specific lsp helpers
  },
  config = function()
    require("lspconfig")
    require("user.plugins.config.lsp.mason")
    require("user.plugins.config.lsp.handlers").setup()
  end
}
