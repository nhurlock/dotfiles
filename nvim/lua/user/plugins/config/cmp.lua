---@type LazyPluginSpec
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",                  -- buffer completions
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",                    -- path completions
    "hrsh7th/cmp-cmdline",                 -- cmdline completions
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp-signature-help", -- signature completions
    "saadparwaiz1/cmp_luasnip",            -- snippet completions
    "zbirenbaum/copilot-cmp",              -- copilot completions

    -- snippets
    "L3MON4D3/LuaSnip",                         --snippet engine
    "rafamadriz/friendly-snippets",             -- a bunch of snippets to use

    { "nhurlock/jira-issues.nvim", dev = true } -- work-only
  },
  init = function()
    require("luasnip/loaders/from_vscode").lazy_load()
  end,
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    require("copilot_cmp").setup()

    local jira_issues_source_ok, jira_issues_source = pcall(require, "jira-issues.completion.cmp")
    local jira_config_ok, jira_config = pcall(require, "user.config.jira")
    if jira_config_ok and jira_issues_source_ok then
      cmp.register_source("jira_issues", jira_issues_source.new(jira_config))
    end

    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    cmp.event:on("menu_opened", function()
      vim.b.copilot_suggestion_hidden = true
    end)
    cmp.event:on("menu_closed", function()
      vim.b.copilot_suggestion_hidden = false
    end)

    local kind_icons = {
      Text = "󰉿",
      Method = "m",
      Function = "󰊕",
      Constructor = "",
      Field = "",
      Variable = "󰆧",
      Class = "󰌗",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰇽",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰊄",
      Codeium = "󰚩",
      Copilot = "",
      Jira = "󰌃",
      AWS = "󰸏"
    }

    cmp.setup({
      enabled = function()
        return vim.bo.filetype ~= "prompt"
      end,
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = {
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-v>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-y>"] = cmp.mapping(function(fallback)
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-l>"] = cmp.mapping(cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true
        }), { "i", "c" }),
        ["<C-e>"] = cmp.mapping.abort()
      },
      formatting = {
        expandable_indicator = true,
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          -- kind icons
          vim_item.kind = kind_icons[vim_item.kind]
          if entry.source.name == "nvim_lsp" then
            pcall(function()
              if entry.source.source.client.name then
                if entry.source.source.client.name == 'cfn_lsp' then
                  vim_item.kind = kind_icons.AWS
                end
              end
            end)
          end
          if entry.source.name == "jira_issues" then
            vim_item.kind = kind_icons.Jira
          end
          -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
          -- vim_item.menu = ({
          --       nvim_lsp = "[LSP]",
          --       nvim_lua = "[NVIM_LUA]",
          --       luasnip = "[Snippet]",
          --       buffer = "[Buffer]",
          --       path = "[Path]",
          --     })[entry.source.name]
          return vim_item
        end,
      },
      sources = cmp.config.sources({
        -- { name = "nvim_lsp_signature_help" },
        { name = "jira_issues", max_item_count = 10 },
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
      }, {
        { name = "buffer", group_index = 2 },
      }, {
        { name = "luasnip", group_index = 3 },
        { name = "path",    group_index = 3 },
      }),
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      window = {
        documentation = cmp.config.window.bordered({
          border = "solid",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:None"
        })
      },
      experimental = {
        ghost_text = true,
      }
    })
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "nvim_lua" },
      }, {
        { name = 'buffer' }
      })
    })
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "jira_issues", max_item_count = 10 },
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
  end
}
