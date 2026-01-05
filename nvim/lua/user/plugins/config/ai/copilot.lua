local utils = require('user.utilities')

---@type LazyPluginSpec[]
return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    dependencies = {
      {
        'copilotlsp-nvim/copilot-lsp',
        init = function()
          vim.g.copilot_nes_debounce = 500
        end,
      },
    },
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
      nes = {
        enabled = true,
        keymap = {
          accept_and_goto = '<M-L>',
          accept = false,
          dismiss = '<esc>',
        },
      },
      suggestion = {
        enabled = false,
        auto_trigger = false,
        hide_during_completion = true,
        trigger_on_accept = true,
        debounce = 75,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = false,
          next = false,
          prev = false,
          dismiss = false,
        },
      },
    },
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
        http = {
          copilot = function()
            return require('codecompanion.adapters.http').extend('copilot', {
              schema = {
                model = {
                  default = 'claude-sonnet-4.5',
                },
              },
            })
          end,
        },
      },
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            -- MCP Tools
            make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
            show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
            add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
            show_result_in_chat = true, -- Show tool results directly in chat buffer
            format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
            -- MCP Resources
            make_vars = true, -- Convert MCP resources to #variables for prompts
            -- MCP Prompts
            make_slash_commands = true, -- Add MCP prompts as /slash commands
          },
        },
      },
      interactions = {
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
      providers = {
        copilot = {
          model = 'claude-sonnet-4.5',
        },
      },
      file_selector = {
        provider = 'fzf',
      },
      selector = {
        exclude_auto_select = { 'ministarter' },
      },
      selection = {
        hint_display = 'none',
      },
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
}
