-- automatically install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

lazy.setup("user.plugins.config", {
  dev = {
    path = "$dev",
    patterns = { "nhurlock" }
  },
  install = { colorscheme = { "catppuccin" } },
  performance = {
    rtp = {
      disabled_plugins = {
        "matchit"
      }
    }
  }
})
