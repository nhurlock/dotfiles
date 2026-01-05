vim.g.ai_provider = 'llama'

if vim.env.USER ~= 'nhurlock' then
  vim.g.ai_provider = 'copilot'
end

---@type LazyPluginSpec[]
local plugins = {
  {
    import = 'user.plugins.config.ai.' .. ((vim.g.ai_provider == 'copilot' and 'copilot') or 'llama.init'),
  },
  {
    'ravitemer/mcphub.nvim',
    build = 'npm install -g mcp-hub@latest',
    config = true,
  },
  {
    'NickvanDyke/opencode.nvim',
    keys = {
      {
        '<leader>oA',
        function()
          require('opencode').ask()
        end,
        desc = 'Opencode ask',
      },
      {
        '<leader>oa',
        function()
          require('opencode').ask('@cursor: ')
        end,
        desc = 'Opencode ask about cursor',
        mode = 'n',
      },
      {
        '<leader>oa',
        function()
          require('opencode').ask('@selection: ')
        end,
        desc = 'Opencode ask about selection',
        mode = 'v',
      },
      {
        '<leader>oc',
        function()
          require('opencode').toggle()
        end,
        desc = 'Opencode toggle embedded',
      },
      {
        '<leader>on',
        function()
          require('opencode').command('session_new')
        end,
        desc = 'Opencode new session',
      },
      {
        '<leader>oy',
        function()
          require('opencode').command('messages_copy')
        end,
        desc = 'Opencode copy last message',
      },
      {
        '<M-C-u>',
        function()
          require('opencode').command('messages_half_page_up')
        end,
        desc = 'Opencode scroll messages up',
      },
      {
        '<M-C-d>',
        function()
          require('opencode').command('messages_half_page_down')
        end,
        desc = 'Opencode scroll messages down',
      },
      {
        '<leader>op',
        function()
          require('opencode').select_prompt()
        end,
        desc = 'Opencode select prompt',
        mode = { 'n', 'v' },
      },
    },
  },
}

return vim.tbl_map(function(plugin)
  plugin.cond = (plugin.cond or true) and vim.env.KITTY_SCROLLBACK_NVIM ~= 'true'
  return plugin
end, plugins)
