return {
  "folke/noice.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>nl", "<cmd>Noice last<cr>",      mode = { "n" }, silent = true, noremap = true, desc = "Noice show last" },
    { "<leader>nh", "<cmd>Noice history<cr>",   mode = { "n" }, silent = true, noremap = true, desc = "Noice view history" },
    { "<leader>nd", "<cmd>Noice dismiss<cr>",   mode = { "n" }, silent = true, noremap = true, desc = "Noice dismiss all" },
    { "<leader>nt", "<cmd>Noice telescope<cr>", mode = { "n" }, silent = true, noremap = true, desc = "Noice view history in Telescope" }
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        render = "compact",
        stages = require('user.plugins.config.noice.stages.fade')(),
        timeout = 500
      }
    }
  },
  opts = {
    cmdline = {
      format = {
        search_down = { kind = "search", pattern = "^/", icon = "  ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = "  ", lang = "regex" }
      }
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
        },
        opts = { skip = true },
      },
    },
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true
      },
      -- these hover settings don't work with noice properly, have to modify noice, future PR to fix
      hover = {
        opts = {
          border = {
            style = "none",
            padding = { 1, 1, 1, 1 }
          },
          -- position = { row = 2, col = 1 }
        }
      },
      signature = {
        opts = {
          border = {
            style = "none",
            padding = { 1, 1, 1, 1 }
          },
          -- position = { row = 2, col = 1 }
        }
      }
      -- hover = {
      --   opts = {
      --     border = {
      --       style = "none",
      --       padding = { 1, 2 }
      --     },
      --     position = { row = 2, col = 2 }
      --   }
      -- },
      -- signature = {
      --   opts = {
      --     border = {
      --       style = "none",
      --       padding = { 1, 2 }
      --     },
      --     position = { row = 2, col = 2 }
      --   }
      -- }
    },
    presets = {
      bottom_search = true,         -- use a classic bottom cmdline for search
      command_palette = true,       -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false,           -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false,       -- add a border to hover docs and signature help
    }
  }
}
