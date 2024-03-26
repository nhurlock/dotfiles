---@type LazyPluginSpec
return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npx --yes yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  cmd = {
    "MarkdownPreview",
    "MarkdownPreviewToggle"
  },
  ft = { "markdown" }
}
