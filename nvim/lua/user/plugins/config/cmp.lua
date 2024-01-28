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

    -- snippets
    "L3MON4D3/LuaSnip",             --snippet engine
    "rafamadriz/friendly-snippets", -- a bunch of snippets to use
  },
  init = function()
    require("luasnip/loaders/from_vscode").lazy_load()
  end,
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

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
      AWS = "󰸏"
    }

    cmp.setup({
      enabled = function() return vim.fn.getbufvar(0, "buftype") ~= "prompt" end,
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
        ["<C-f>"] = cmp.mapping(function()
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),
        ["<C-v>"] = cmp.mapping(function()
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-y>"] = cmp.mapping(function()
          if luasnip.choice_active() then
            luasnip.change_choice(1)
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
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
  end
}
