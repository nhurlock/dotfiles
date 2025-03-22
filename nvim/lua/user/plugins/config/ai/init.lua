vim.g.ai_provider = 'llama'

if vim.env.USER ~= 'nhurlock' then
  vim.g.ai_provider = 'copilot'
end

---@type LazyPluginSpec
return { import = 'user.plugins.config.ai' }
