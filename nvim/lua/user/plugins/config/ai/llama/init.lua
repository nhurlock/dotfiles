-- llama-server --fim-qwen-7b-default --port 8012
-- llama-server --jinja -fa -c 0 -hf unsloth/Qwen2.5-Coder-14B-Instruct-128K-GGUF --port 8080
-- llama-server --jinja -fa -c 0 -hf unsloth/Qwen3-14B-GGUF --port 8080

---@type LazyPluginSpec[]
return {
  {
    'nhurlock/llama.vim',
    dev = true,
    init = function()
      vim.g.llama_config = {
        show_info = 0,
        n_predict = 512,
        ghost_text_enabled = false,
        keymaps_enabled = false,
      }
    end,
    config = function()
      vim.api.nvim_set_hl(0, 'llama_hl_hint', { link = 'Comment', force = true })
      vim.api.nvim_set_hl(0, 'llama_hl_info', { link = 'Comment', force = true })
    end,
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
          llama = function()
            return require('codecompanion.adapters.http').extend('openai_compatible', {
              env = {
                url = 'http://localhost:8080',
              },
              schema = {
                model = {
                  default = '',
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
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
      interactions = {
        chat = {
          adapter = 'llama',
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
          adapter = 'llama',
        },
        cmd = {
          adapter = 'llama',
        },
      },
    },
  },
  -- {
  --   'milanglacier/minuet-ai.nvim',
  --   opts = {
  --     provider = 'openai_fim_compatible',
  --     n_completions = 2,
  --     context_window = 2000,
  --     provider_options = {
  --       openai_fim_compatible = {
  --         api_key = 'TERM',
  --         name = 'llama',
  --         end_point = 'http://localhost:8012/v1/completions',
  --         model = 'NA',
  --         optional = {
  --           max_tokens = 256,
  --           top_p = 0.9,
  --         },
  --         template = {
  --           suffix = false,
  --           prompt = function(context_before_cursor, context_after_cursor)
  --             return '<|fim_prefix|>'
  --               .. context_before_cursor
  --               .. '<|fim_suffix|>'
  --               .. context_after_cursor
  --               .. '<|fim_middle|>'
  --           end,
  --         },
  --       },
  --     },
  --   },
  -- },
}
