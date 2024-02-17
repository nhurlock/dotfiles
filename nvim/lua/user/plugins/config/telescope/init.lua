local function projects_picker()
  require('user.plugins.config.telescope.pickers.projects')()
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-media-files.nvim",
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
  },
  keys = {
    { "<leader>ff",  "<cmd>Telescope find_files<cr>",                               mode = { "n" }, silent = true, noremap = true, desc = "Telescope find files" },
    {
      "<leader>fF",
      function()
        local dir = vim.fn.expand("%:h")
        vim.cmd("Telescope find_files cwd=" .. dir)
      end,
      mode = { "n" },
      silent = true,
      noremap = true,
      desc = "Telescope find files in current directory"
    },
    { "<leader>fgf", "<cmd>Telescope git_files<cr>",                                mode = { "n" }, silent = true, noremap = true, desc = "Telescope git files" },
    { "<leader>fgc", "<cmd>Telescope git_commits<cr>",                              mode = { "n" }, silent = true, noremap = true, desc = "Telescope git commits" },
    { "<leader>fgb", "<cmd>Telescope git_branches<cr>",                             mode = { "n" }, silent = true, noremap = true, desc = "Telescope git branches" },
    { "<leader>fl",  "<cmd>Telescope live_grep<cr>",                                mode = { "n" }, silent = true, noremap = true, desc = "Telescope live grep" },
    { "<leader>fb",  "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", mode = { "n" }, silent = true, noremap = true, desc = "Telescope buffers" },
    { "<leader>fd",  "<cmd>Telescope diagnostics<cr>",                              mode = { "n" }, silent = true, noremap = true, desc = "Telescope diagnostics" },
    { "<leader>fh",  "<cmd>Telescope help_tags<cr>",                                mode = { "n" }, silent = true, noremap = true, desc = "Telescope help tags" },
    { "<leader>fr",  "<cmd>Telescope lsp_references<cr>",                           mode = { "n" }, silent = true, noremap = true, desc = "Telescope LSP references" },
    { "<leader>fe",  "<cmd>Telescope resume<cr>",                                   mode = { "n" }, silent = true, noremap = true, desc = "Telescope resume" },
    { "<leader>fj",  "<cmd>Telescope jumplist<cr>",                                 mode = { "n" }, silent = true, noremap = true, desc = "Telescope jumplist" },
    { "<leader>fm",  "<cmd>Telescope marks<cr>",                                    mode = { "n" }, silent = true, noremap = true, desc = "Telescope marks" },
    { "<leader>fq",  "<cmd>Telescope quickfix<cr>",                                 mode = { "n" }, silent = true, noremap = true, desc = "Telescope quickfix" },
    { "<leader>fs",  "<cmd>Telescope spell_suggest<cr>",                            mode = { "n" }, silent = true, noremap = true, desc = "Telescope spelling suggestions" },
    { "<leader>ft",  "<cmd>Telescope treesitter<cr>",                               mode = { "n" }, silent = true, noremap = true, desc = "Telescope treesitter" },
    { "<leader>fz",  "<cmd>Telescope current_buffer_fuzzy_find<cr>",                mode = { "n" }, silent = true, noremap = true, desc = "Telescope fuzzy find in current buffer" },
    { "gd",          "<cmd>Telescope lsp_definitions reuse_win=true<cr>",           mode = { "n" }, silent = true, noremap = true, desc = "Telescope LSP go to definition" },
    { "gi",          "<cmd>Telescope lsp_implementations reuse_win=true<cr>",       mode = { "n" }, silent = true, noremap = true, desc = "Telescope LSP go to implementation" },
    { "gt",          "<cmd>Telescope lsp_type_definitions reuse_win=true<cr>",      mode = { "n" }, silent = true, noremap = true, desc = "Telescope LSP go to type definition" },
    { "<leader>fp",  projects_picker,                                               mode = { "n" }, silent = true, noremap = true, desc = "Telescope projects" }
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local picker_layout_strategies = require("telescope.pickers.layout_strategies")

    picker_layout_strategies.horizontal_custom = function(picker, max_columns, max_lines, layout_config)
      picker.layout_config.horizontal.prompt_position = "top"
      local layout = picker_layout_strategies.horizontal(picker, max_columns, max_lines, layout_config)
      layout.results.title = ''
      layout.results.line = layout.results.line - 1
      layout.results.height = layout.results.height + 1
      layout.results.borderchars = { "─", "│", "─", "│", "│", "│", "╯", "╰" }
      if layout.preview ~= false then
        layout.preview.borderchars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }
        layout.preview.title = ''
      end
      layout.prompt.borderchars = { "─", "│", "─", "│", "╭", "╮", "│", "│" }
      return layout
    end

    picker_layout_strategies.vertical_custom = function(picker, max_columns, max_lines, layout_config)
      local layout = picker_layout_strategies.vertical(picker, max_columns, max_lines, layout_config)
      layout.results.borderchars = { "─", "│", "─", "│", "╭", "╮", "│", "│" }
      layout.results.line = layout.results.line - 1
      layout.results.height = layout.results.height + 1
      if layout.preview ~= false then
        layout.results.title = ''
        layout.preview.title = layout.prompt.title
        layout.preview.borderchars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }
      end
      layout.prompt.title = ''
      layout.prompt.borderchars = { "─", "│", "─", "│", "│", "│", "╯", "╰" }
      layout.prompt.line = layout.prompt.line - 1
      return layout
    end

    telescope.setup({
      defaults = {
        layout_strategy = "horizontal_custom",
        sorting_strategy = "ascending",
        prompt_prefix = " ",
        selection_caret = " ",
        -- path_display = { "smart" },
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-c>"] = actions.close,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.add_to_qflist,
            ["<M-q>"] = actions.add_selected_to_qflist,
            ["<C-l>"] = actions.open_qflist,
            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
          },
          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.add_to_qflist,
            ["<M-q>"] = actions.add_selected_to_qflist,
            ["<C-l>"] = actions.open_qflist,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["?"] = actions.which_key
          }
        },
        preview = {
          filetype_hook = function(filepath, bufnr, opts)
            local api = require("image")
            local preview_id = "telescope_preview"
            api.clear(preview_id)

            local is_image = function(filepath)
              local image_extensions = { "png", "jpg", "jpeg", "gif", "webp" }
              local split_path = vim.split(filepath:lower(), ".", { plain = true })
              local extension = split_path[#split_path]
              return vim.tbl_contains(image_extensions, extension)
            end

            if is_image(filepath) then
              api.hijack_buffer(filepath, opts.winid, bufnr, { id = preview_id })
              return false
            end
            return true
          end
        }
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = true,
        },
        git_files = {
          hidden = true,
          no_ignore = false,
        },
        diagnostics = {
          layout_strategy = "vertical_custom",
          sorting_strategy = "descending",
        },
        buffers = {
          layout_strategy = "vertical_custom",
          sorting_strategy = "descending",
          attach_mappings = function(_, map)
            map("i", "<C-x>", actions.delete_buffer)
            map("n", "dd", actions.delete_buffer)
            return true
          end
        },
        quickfix = {
          layout_strategy = "vertical_custom",
          sorting_strategy = "descending",
        },
        marks = {
          layout_strategy = "vertical_custom",
          sorting_strategy = "descending",
          attach_mappings = function(_, map)
            map("i", "<C-x>", actions.delete_mark)
            map("n", "dd", actions.delete_mark)
            return true
          end
        },
        jumplist = {
          layout_strategy = "vertical_custom",
          sorting_strategy = "descending",
        },
        help_tags = {
          layout_strategy = "vertical_custom",
          sorting_strategy = "descending",
        },
        live_grep = {
          layout_strategy = "vertical_custom",
          sorting_strategy = "descending",
        },
        lsp_references = {
          layout_strategy = "vertical_custom",
          sorting_strategy = "descending",
        },
        lsp_definitions = {
          layout_strategy = "vertical_custom",
          sorting_strategy = "descending",
        },
        lsp_implementations = {
          layout_strategy = "vertical_custom",
          sorting_strategy = "descending",
        },
        current_buffer_fuzzy_find = {
          layout_strategy = "vertical_custom",
          sorting_strategy = "descending",
        },
        spell_suggest = {
          theme = "cursor"
        }
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
        media_files = {
          filetypes = { "png", "webp", "jpg", "jpeg" },
          find_cmd = "rg"
        }
      }
    })

    -- guifg=#cad3f5 guibg=#1e2030
    -- actualbg=#161723 is guibg with 5% less L (HSL)
    -- actualfg=#232638 is guifg with 3% more L (HSL)
    vim.cmd [[highlight! link TelescopePreviewNormal Normal]]
    vim.cmd [[highlight! link TelescopeNormal NormalFloat]]
    vim.cmd [[highlight! link TelescopeBorder FloatBorder]]
    vim.cmd [[highlight! link TelescopeTitle FloatTitle]]
    vim.cmd [[highlight NormalFloat guifg=#cad3f5 guibg=#161723]]
    vim.cmd [[highlight FloatBorder guifg=#232638 guibg=#161723]]
    vim.cmd [[highlight FloatTitle guifg=#cad3f5 guibg=#161723]]

    telescope.load_extension('media_files')
    telescope.load_extension('fzf')
  end
}
