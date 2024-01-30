return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim"
  },
  cmd = "Neotree",
  keys = {
    {
      "<leader>v",
      "<cmd>Neotree toggle<cr>",
      mode = { "n" },
      silent = true,
      noremap = true,
      desc = "Neotree toggle"
    },
    {
      "<leader>V",
      "<cmd>Neotree<cr>",
      mode = { "n" },
      silent = true,
      noremap = true,
      desc = "Neotree open/focus"
    }
  },
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
  end,
  opts = {
    git_status_async = true,
    enable_cursor_hijack = true,
    event_handlers = {
      {
        id = "neo-tree-first-open",
        event = "vim_buffer_enter",
        handler = function()
          -- enforce that neo-tree maintains its small size
          for _, id in ipairs(vim.api.nvim_list_wins()) do
            local win_ok, buf = pcall(vim.api.nvim_win_get_buf, id)
            if win_ok and vim.bo[buf].filetype == "neo-tree" then
              pcall(vim.api.nvim_win_set_width, buf, 40)
              break
            end
          end
        end
      }
    },
    window = {
      position = "right",
      mappings = {
        ["o"] = { "toggle_node", nowait = false },
        ["<2-LeftMouse>"] = "actual_open",
        ["<cr>"] = "actual_open",
        ["<esc>"] = "revert_preview",
        ["P"] = { "toggle_preview", config = { use_float = true } },
        ["l"] = "focus_preview",
        ["S"] = "open_split",
        ["s"] = "open_vsplit",
        ["t"] = "open_tabnew",
        ["C"] = "close_node",
        ["z"] = "close_all_nodes",
        ["Z"] = "expand_all_nodes",
        ["R"] = "refresh",
        ["a"] = {
          "add",
          config = {
            show_path = "none", -- "none", "relative", "absolute"
          }
        },
        ["A"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ["m"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ["e"] = "toggle_auto_expand_width",
        ["q"] = "close_window",
        ["?"] = "show_help",
        ["<"] = "prev_source",
        [">"] = "next_source",
      },
    },
    popup_border_style = "NC",
    hide_root_node = true,
    nesting_rules = {
      ["ts"] = {
        pattern = "(.*)%.ts$",
        files = { "%1.*.ts", "%1.ts.*" }
      },
      ["js"] = {
        pattern = "(.*)%.js$",
        files = { "%1.*.js", "%1.js.*" }
      }
    },
    filesystem = {
      use_libuv_file_watcher = true,
      find_by_full_path_words = true,
      follow_current_file = {
        enabled = true
      },
      group_empty_dirs = false,
      window = {
        mappings = {
          ["H"] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
          ["D"] = "fuzzy_finder_directory",
          --["/"] = "filter_as_you_type", -- this was the default until v1.28
          ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
          -- ["D"] = "fuzzy_sorter_directory",
          ["f"] = "filter_on_submit",
          ["<C-x>"] = "clear_filter",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
        },
        fuzzy_finder_mappings = {
          -- define keymaps for filter popup window in fuzzy_finder_mode
          ["<down>"] = "move_cursor_down",
          ["<C-j>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<C-k>"] = "move_cursor_up",
        },
      }
    },
    buffers = {
      window = {
        mappings = {
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["bd"] = "buffer_delete",
        },
      }
    },
    git_status = {
      window = {
        mappings = {
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gA"] = "git_add_all",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
        },
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = false
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        folder_empty_open = "",
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = "*",
        highlight = "NeoTreeFileIcon"
      },
      modified = {
        symbol = "",
        highlight = "NeoTreeModified",
      },
      git_status = {
        symbols = {
          -- Change type
          added     = "",
          deleted   = "",
          modified  = "",
          renamed   = "➜",
          -- Status type
          untracked = "*",
          ignored   = "",
          unstaged  = "-",
          staged    = "",
          conflict  = "",
        },
        align = "right"
      },
    }
  },
  config = function(_, opts)
    local colors = require('catppuccin.palettes').get_palette()
    local actual_open = require("user.plugins.config.neo-tree.actual-open")
    opts.commands = { actual_open = actual_open }
    require("neo-tree").setup(opts)

    -- override default window finder with custom picker to mimic nvim-tree
    local utils = require("neo-tree.utils")
    ---@diagnostic disable-next-line: duplicate-set-field
    utils.open_file = actual_open

    -- removes the "Window settings restored" message
    vim.api.nvim_del_augroup_by_name("NeoTree_BufLeave")
    local bufenter = function(ev)
      local pattern = "neo%-tree [^ ]+ %[1%d%d%d%]"
      if string.match(ev.file, pattern) then
        vim.w.neo_tree_alternate_nr = vim.fn.bufnr "#" ---@diagnostic disable-line: param-type-mismatch
      end
    end
    vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
      group = vim.api.nvim_create_augroup("NeoTree_BufEnter", { clear = true }),
      pattern = "neo-tree *",
      callback = bufenter,
    })

    vim.cmd("highlight! NeoTreeWindowPicker guifg=" .. colors.base .. " guibg=" .. colors.mauve)

    vim.cmd("highlight! NeoTreeGitAdded guifg=" .. colors.teal)
    vim.cmd("highlight! NeoTreeGitDeleted guifg=" .. colors.rosewater)
    vim.cmd("highlight! NeoTreeGitModified guifg=" .. colors.yellow)
    vim.cmd("highlight! NeoTreeGitRenamed guifg=" .. colors.flamingo)

    vim.cmd("highlight! NeoTreeGitUntracked guifg=" .. colors.lavender)
    vim.cmd [[highlight! link NeoTreeGitIgnored Comment]]
    vim.cmd("highlight! NeoTreeGitUnstaged guifg=" .. colors.yellow)
    vim.cmd("highlight! NeoTreeGitStaged guifg=" .. colors.green)
    vim.cmd("highlight! NeoTreeGitConflict guifg=" .. colors.red)

    vim.cmd [[highlight! link NeoTreeHiddenByName Comment]]
    vim.cmd [[highlight! link NeoTreeWindowsHidden Comment]]
    vim.cmd [[highlight! link NeoTreeDimText Comment]]
    vim.cmd [[highlight! link NeoTreeDotfile Comment]]

    vim.cmd [[highlight! link NeoTreeTitleBar FloatTitle]]
    vim.cmd [[highlight! link NeoTreeFloatBorder FloatBorder]]
    vim.cmd [[highlight! link NeoTreeFloatTitle FloatTitle]]
    vim.cmd [[highlight! link NeoTreeFloatNormal FloatNormal]]
  end
}
