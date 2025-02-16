---@type LazyPluginSpec
return {
  "saghen/blink.cmp",
  version = '*',
  build = 'cargo build --release',
  dependencies = {
    { "saghen/blink.compat", version = "*",   lazy = true, opts = {} },

    -- `main` does not work at the moment
    { 'L3MON4D3/LuaSnip',    version = 'v2.*' }, -- snippet engine
    "rafamadriz/friendly-snippets",              -- a bunch of snippets to use

    -- nvim_cmp sources, to be replaced/updated
    "hrsh7th/cmp-cmdline",                                                            -- cmdline completions
    "zbirenbaum/copilot-cmp",                                                         -- copilot completions
    { "nhurlock/jira-issues.nvim", enabled = vim.env.USER ~= "nhurlock", dev = true } -- work-only
  },
  config = function()
    local cmp = require("blink.cmp")

    local kind_icons = {
      Text = "󰉿",
      Method = "m",
      Function = "󰊕",
      Constructor = "",

      Field = "",
      Variable = "󰆧",
      Property = "",

      Class = "󰌗",
      Interface = "",
      Struct = "",
      Module = "",

      Unit = "",
      Value = "󰎠",
      Enum = "",
      EnumMember = "",

      Keyword = "󰌋",
      Constant = "󰇽",

      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰊄",

      Codeium = "󰚩",
      Copilot = "",
      Jira = "󰌃",
      AWS = "󰸏"
    }

    require("copilot_cmp").setup()
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
    --  - jira_issues provider
    --  - handle cfn_lsp case for custom 'AWS' kind icon

    cmp.setup({
      keymap = {
        preset = "none",
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-f>"] = { "snippet_backward", "fallback" },
        ["<C-v>"] = { "snippet_forward", "fallback" },
        ["<C-Space>"] = { "show", "fallback" },
        ["<C-l>"] = { "select_and_accept", "fallback" },
        ["<C-e>"] = { "hide", "fallback" }
      },
      sources = {
        default = { 'copilot', 'lsp', 'buffer', 'snippets', 'path' },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink.compat.source"
          },
          cmdline = {
            name = "cmdline",
            module = "blink.compat.source"
          }
        }
      },
      cmdline = {
        sources = function()
          if vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype()) then
            return { "path", "buffer" }
          end
          return { "path", "buffer", "cmdline" }
        end
      },
      signature = {
        enabled = true,
        window = {
          show_documentation = false
        }
      },
      snippets = { preset = 'luasnip' },
      completion = {
        list = {
          selection = {
            preselect = false,
            auto_insert = function(ctx) return ctx.mode == 'cmdline' end
          }
        },
        menu = {
          auto_show = true,
          border = "none",
          draw = {
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  if ctx.source_name == "jira_issues" then
                    return kind_icons.Jira
                  end
                  return kind_icons[ctx.kind]
                end
              }
            },
            columns = {
              { "kind_icon", gap = 1 },
              { "label",     "label_description" }
            }
          }
        },
        documentation = {
          auto_show = true
        },
        ghost_text = {
          enabled = true
        }
      },
      appearance = {
        kind_icons = kind_icons
      }
    })
  end
}
