local utils = require('user.utilities')

---@type LazyPluginSpec[]
return {
  {
    'zbirenbaum/copilot.lua',
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
    ---@type CopilotConfig
    opts = {
      copilot_model = 'gpt-4o-copilot',
      server = {
        type = 'binary',
      },
      filetypes = {
        ['yaml.cloudformation'] = true,
      },
      suggestion = {
        enabled = false,
        auto_trigger = false,
        hide_during_completion = true,
        trigger_on_accept = true,
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
    'copilotlsp-nvim/copilot-lsp',
    cond = false,
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable('copilot_ls')
      vim.keymap.set({ 'n', 'i' }, '<C-l>', function()
        if not require('blink.cmp').is_visible() then
          -- Try to jump to the start of the suggestion edit.
          -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
          local _ = require('copilot-lsp.nes').walk_cursor_start_edit()
            or (require('copilot-lsp.nes').apply_pending_nes() and require('copilot-lsp.nes').walk_cursor_end_edit())
        end
      end)
    end,
  },
  {
    'fang2hou/blink-copilot',
  },
  {
    'olimorris/codecompanion.nvim',
    opts = {
      display = {
        action_palette = {
          provider = 'fzf_lua',
        },
      },
      adapters = {
        copilot = function()
          return require('codecompanion.adapters').extend('copilot', {
            schema = {
              model = {
                default = 'claude-3.7-sonnet',
              },
            },
          })
        end,
      },
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
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
    },
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false,
    build = 'make',
    opts = {
      provider = 'copilot',
      copilot = {
        model = 'claude-3.7-sonnet',
      },
      file_selector = {
        provider = 'fzf',
      },
      selector = {
        exclude_auto_select = { 'ministarter' },
      },
      hints = { enabled = false },
      behaviour = {
        auto_suggestions = false, -- provided by copilot.lua
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
        enable_token_counting = true,
        enable_cursor_planning_mode = true,
        enable_claude_text_editor_tool_mode = true,
      },
      system_prompt = function()
        local hub = require('mcphub').get_hub_instance()
        if not hub then
          return nil
        end
        return hub:get_active_servers_prompt()
      end,
      custom_tools = function()
        return {
          require('mcphub.extensions.avante').mcp_tool(),
        }
      end,
    },
  },
  {
    'ravitemer/mcphub.nvim',
    build = 'npm install -g mcp-hub@latest',
    config = true,
  },
}
