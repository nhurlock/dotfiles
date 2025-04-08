local utils = require('user.utilities')

---@type LazyPluginSpec[]
return {
  {
    'zbirenbaum/copilot.lua',
    enabled = vim.g.ai_provider == 'copilot',
    cmd = 'Copilot',
    event = 'InsertEnter',
    keys = utils.lazy_maps({
      {
        '<M-Space>',
        function()
          local copilot = require('copilot.client')
          local suggestion = require('copilot.suggestion')
          if copilot.is_disabled() then
            vim.cmd('Copilot enable')
            vim.cmd('Copilot suggestion')
            vim.b.copilot_suggestion_auto_trigger = true
          else
            if suggestion.is_visible() then
              suggestion.dismiss()
            end
            vim.cmd('Copilot disable')
            vim.b.copilot_suggestion_auto_trigger = false
          end
        end,
        { 'n', 'i' },
        'Copilot toggle',
      },
    }),
    ---@type copilot_config
    opts = {
      model = 'claude-3.5-sonnet',
      filetypes = {
        ['yaml.git_actions'] = true,
        ['yaml.cloudformation'] = true,
      },
      suggestion = {
        enabled = false,
        auto_trigger = false,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = '<M-l>',
          accept_word = false,
          accept_line = '<M-L>',
          next = '<M-J>',
          prev = '<M-K>',
          dismiss = false,
        },
      },
    },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    enabled = vim.g.ai_provider == 'copilot',
    config = true,
  },
  {
    'giuxtaposition/blink-cmp-copilot',
    enabled = vim.g.ai_provider == 'copilot',
  },
  {
    'olimorris/codecompanion.nvim',
    opts = function()
      return {
        adapters = {
          copilot = function()
            return require('codecompanion.adapters').extend('copilot', {
              schema = {
                model = {
                  default = 'claude-3.5-sonnet',
                },
              },
            })
          end,
        },
        strategies = {
          chat = {
            adapter = 'copilot',
            slash_commands = {
              ['file'] = {
                callback = 'strategies.chat.slash_commands.file',
                description = 'Select a file using fzf',
                opts = {
                  provider = 'fzf_lua',
                  contains_code = true,
                },
              },
            },
          },
          inline = {
            adapter = 'copilot',
          },
          cmd = {
            adapter = 'copilot',
          },
        },
        opts = {
          log_level = 'DEBUG',
        },
      }
    end,
  },
  {
    'yetone/avante.nvim',
    enabled = false, -- disabled for now since codecompanion seems to provide greater value
    event = 'VeryLazy',
    version = false,
    build = 'make',
    opts = {
      provider = 'copilot',
      file_selector = {
        provider = 'fzf',
      },
      hints = { enabled = false },
      behaviour = {
        auto_suggestions = false, -- provided by copilot.lua
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
        enable_token_counting = false,
        enable_cursor_planning_mode = true,
      },
    },
  },
}
