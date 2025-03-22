---@type LazyPluginSpec
return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  build = 'cargo build --release',
  dependencies = {
    { 'saghen/blink.compat', version = '*', lazy = true, opts = {} },

    -- `main` does not work at the moment
    { 'L3MON4D3/LuaSnip', version = 'v2.*' }, -- snippet engine
    'rafamadriz/friendly-snippets', -- a bunch of snippets to use

    { 'nhurlock/jira-issues.nvim', enabled = vim.env.USER ~= 'nhurlock', dev = true }, -- work-only
  },
  config = function()
    local cmp = require('blink.cmp')
    local icons = require('mini.icons')
    local has_jira, _ = pcall(require, 'jira-issues.completion.blink')

    local kind_icons = {
      Copilot = '',
      AI = '󰚩',
      Jira = '󰌃',
      AWS = '󰸏',
    }

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuOpen',
      callback = function()
        vim.b.copilot_suggestion_hidden = true
      end,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuClose',
      callback = function()
        vim.b.copilot_suggestion_hidden = false
      end,
    })

    -- missing/todo:
    --  - replace behavior
    --  - handle cfn_lsp case for custom 'AWS' kind icon

    local opts = {
      enabled = function()
        return vim.bo.filetype ~= 'typr'
          and vim.bo.filetype ~= 'minifiles'
          and vim.bo.buftype ~= 'prompt'
          and vim.b.completion ~= false
      end,
      keymap = {
        preset = 'none',
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-f>'] = { 'snippet_backward', 'fallback' },
        ['<C-v>'] = { 'snippet_forward', 'fallback' },
        ['<C-Space>'] = { 'show', 'fallback' },
        ['<C-l>'] = { 'select_and_accept', 'fallback' },
        ['<C-e>'] = { 'hide', 'fallback' },
      },
      sources = {
        default = {
          'lsp',
          'buffer',
          'snippets',
          'path',
        },
        providers = {},
      },
      term = {
        enabled = true,
        keymap = {
          preset = 'none',
          ['<C-k>'] = { 'select_prev', 'fallback' },
          ['<C-j>'] = { 'select_next', 'fallback' },
          ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
          ['<C-f>'] = { 'snippet_backward', 'fallback' },
          ['<C-v>'] = { 'snippet_forward', 'fallback' },
          ['<C-Space>'] = { 'show', 'fallback' },
          ['<C-l>'] = { 'select_and_accept', 'fallback' },
          ['<C-e>'] = { 'hide', 'fallback' },
        },
        sources = { 'path', 'buffer' },
        completion = {
          list = {
            selection = {
              preselect = false,
              auto_insert = false,
            },
          },
          menu = { auto_show = false },
          ghost_text = { enabled = true },
        },
      },
      cmdline = {
        enabled = true,
        keymap = {
          preset = 'none',
          ['<C-k>'] = { 'select_prev', 'fallback' },
          ['<C-j>'] = { 'select_next', 'fallback' },
          ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
          ['<C-f>'] = { 'snippet_backward', 'fallback' },
          ['<C-v>'] = { 'snippet_forward', 'fallback' },
          ['<C-Space>'] = { 'show', 'fallback' },
          ['<C-l>'] = { 'select_and_accept', 'fallback' },
          ['<C-e>'] = { 'hide', 'fallback' },
        },
        sources = function()
          local sources = { 'path', 'buffer' }
          if not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype()) then
            table.insert(sources, 'cmdline')
          end
          return sources
        end,
        completion = {
          list = {
            selection = {
              preselect = true,
              auto_insert = false,
            },
          },
          menu = { auto_show = true },
          ghost_text = { enabled = true },
        },
      },
      signature = {
        enabled = true,
        trigger = { enabled = true },
        window = { show_documentation = false },
      },
      snippets = { preset = 'luasnip' },
      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        menu = {
          auto_show = true,
          border = 'none',
          draw = {
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  if ctx.source_name == 'minuet' or ctx.source_name == 'llama' then
                    return kind_icons.AI
                  end
                  if ctx.source_name == 'copilot' then
                    return kind_icons.Copilot
                  end
                  if ctx.source_name == 'jira_issues' then
                    return kind_icons.Jira
                  end
                  return icons.get('lsp', ctx.kind)
                end,
                highlight = function(ctx)
                  local _, hl = icons.get('lsp', ctx.kind)
                  return hl
                end,
              },
            },
            columns = {
              { 'kind_icon', gap = 1 },
              { 'label', gap = 1 },
              { 'label_description' },
            },
          },
        },
        documentation = {
          auto_show = true,
          window = {
            border = 'padded',
          },
        },
        ghost_text = { enabled = true },
      },
      appearance = {
        kind_icons = kind_icons,
      },
    }

    if has_jira then
      table.insert(opts.term.sources, 'jira_issues')
      ---@type blink.cmp.SourceProviderConfig
      opts.sources.providers.jira_issues = {
        name = 'jira_issues',
        module = 'jira-issues.completion.blink',
        async = true,
        opts = require('user.config.jira'),
      }
    end

    if vim.g.ai_provider == 'copilot' then
      -- configure copilot
      table.insert(opts.sources.default, 'copilot')
      ---@type blink.cmp.SourceProviderConfig
      opts.sources.providers.copilot = {
        name = 'copilot',
        module = 'blink-cmp-copilot',
        score_offset = 100,
        async = true,
        transform_items = function(_, items)
          local full_line = vim.api.nvim_get_current_line()
          local cursor = vim.api.nvim_win_get_cursor(0)
          local suffix = full_line:sub(cursor[2] + 1)

          return vim.tbl_map(function(item)
            local result = item.textEdit.newText
            local range_end = #full_line + 1

            if vim.endswith(result, suffix) then
              range_end = cursor[2]
              result = result:sub(0, #result - #suffix)
            end

            item.textEdit.newText = result
            item.textEdit.range['end'].character = range_end

            return item
          end, items)
        end,
      }

      -- configure avante
      table.insert(opts.sources.default, 'avante_commands')
      table.insert(opts.sources.default, 'avante_mentions')
      table.insert(opts.sources.default, 'avante_files')
      ---@type blink.cmp.SourceProviderConfig
      opts.sources.providers.avante_commands = {
        name = 'avante_commands',
        module = 'blink.compat.source',
        score_offset = 100,
      }
      ---@type blink.cmp.SourceProviderConfig
      opts.sources.providers.avante_files = {
        name = 'avante_files',
        module = 'blink.compat.source',
        score_offset = 101,
      }
      ---@type blink.cmp.SourceProviderConfig
      opts.sources.providers.avante_mentions = {
        name = 'avante_mentions',
        module = 'blink.compat.source',
        score_offset = 1000,
      }
    elseif vim.g.ai_provider == 'llama' then
      -- configure llama
      table.insert(opts.sources.default, 'llama')
      ---@type blink.cmp.SourceProviderConfig
      opts.sources.providers.llama = {
        name = 'llama',
        module = 'user.plugins.config.ai.llama.cmp',
        score_offset = 100,
        async = true,
      }

      -- configure minuet
      -- table.insert(opts.sources.default, "minuet")
      -- ---@type blink.cmp.SourceProviderConfig
      -- opts.sources.providers.minuet = {
      --   name = 'minuet',
      --   module = 'minuet.blink',
      --   score_offset = 100,
      --   async = true
      -- }
    end

    cmp.setup(opts)
  end,
}
