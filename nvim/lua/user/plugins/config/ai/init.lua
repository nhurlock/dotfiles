vim.g.ai_provider = 'llama'

if vim.env.USER ~= 'nhurlock' then
  vim.g.ai_provider = 'copilot'
end

---@type LazyPluginSpec
return {
  import = (vim.g.ai_provider == 'copilot' and 'user.plugins.config.ai.copilot') or 'user.plugins.config.ai.llama',
  cond = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
}
