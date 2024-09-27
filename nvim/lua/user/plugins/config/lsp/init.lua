---@type LazyPluginSpec
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",           -- simple to use language server installer
    "williamboman/mason-lspconfig.nvim", -- simple to use language server installer
    {
      "folke/lazydev.nvim",              -- lua-specific lsp helpers
      ft = "lua",
      dependencies = {
        { "Bilal2453/luvit-meta",        lazy = true },
        { "justinsgithub/wezterm-types", lazy = true },
      },
      opts = {
        library = {
          { path = "luvit-meta/library", words = { "vim%.uv" } },
          { path = "wezterm-types",      mods = { "wezterm" } },
          { path = "lazy.nvim",          words = { "Lazy" } },
          { path = "barbecue.nvim",      words = { "barbecue.nvim" } },
          { path = "qmk.nvim",           words = { "qmk.nvim" } },
          { path = "zen-mode.nvim",      words = { "zen-mode.nvim" } },
        }
      },
    },
    "pmizio/typescript-tools.nvim", -- javascript/typescript-specific lsp helpers
    "yioneko/nvim-vtsls",           -- javascript/typescript-specific lsp helpers
    "mfussenegger/nvim-jdtls",      -- java-specific lsp helpers
  },
  config = function()
    require("lspconfig")
    require("user.plugins.config.lsp.mason")
    require("user.plugins.config.lsp.handlers").setup()
  end
}
