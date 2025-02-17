local utils = require("user.utilities")
local pickers = require("user.plugins.config.fzf-lua.pickers")

---@type LazyPluginSpec
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  keys = utils.lazy_maps({
    { "<leader>ji",  pickers.jira_issues,                                                                           "n", "FzfLua find Jira issues" },
    { "<leader>fp",  pickers.projects,                                                                              "n", "FzfLua find projects" },
    { "<leader>hi",  pickers.fidget,                                                                                "n", "FzfLua Fidget history" },
    { "<leader>ff",  "FzfLua files",                                                                                "n", "FzfLua find files" },
    { "<leader>fF",  function() require("fzf-lua.providers.files").files({ cwd = vim.fn.expand("%:h") }) end,       "n", "FzfLua find files in current directory" },
    { "<leader>fgf", "FzfLua git_files",                                                                            "n", "FzfLua git files" },
    { "<leader>fgc", "FzfLua git_commits",                                                                          "n", "FzfLua git commits" },
    { "<leader>fg.", "FzfLua git_bcommits",                                                                         "n", "FzfLua git buffer commits" },
    { "<leader>fgb", "FzfLua git_branches",                                                                         "n", "FzfLua git branches" },
    { "<leader>fgs", "FzfLua git_status",                                                                           "n", "FzfLua git status" },
    { "<leader>fgt", "FzfLua git_stash",                                                                            "n", "FzfLua git buffer status" },
    { "<leader>fl",  "FzfLua live_grep",                                                                            "n", "FzfLua live grep" },
    { "<leader>flg", "FzfLua live_grep_glob",                                                                       "n", "FzfLua live grep glob" },
    { "<leader>fb",  "FzfLua buffers",                                                                              "n", "FzfLua buffers" },
    { "<leader>fd",  "FzfLua diagnostics_workspace",                                                                "n", "FzfLua diagnostics" },
    { "<leader>fh",  "FzfLua help_tags",                                                                            "n", "FzfLua help tags" },
    { "<leader>fws", "FzfLua lsp_workspace_symbols",                                                                "n", "FzfLua LSP workspace symbols" },
    { "<leader>fds", "FzfLua lsp_document_symbols",                                                                 "n", "FzfLua LSP document symbols" },
    { "<leader>fr",  "FzfLua lsp_references",                                                                       "n", "FzfLua LSP references" },
    { "<leader>f?",  "FzfLua lsp_finder",                                                                           "n", "FzfLua LSP finder" },
    { "<leader>fy",  "FzfLua registers",                                                                            "n", "FzfLua registers" },
    { "<leader>fe",  "FzfLua resume",                                                                               "n", "FzfLua resume" },
    { "<leader>fj",  "FzfLua jumps",                                                                                "n", "FzfLua jumplist" },
    { "<leader>fm",  "FzfLua marks",                                                                                "n", "FzfLua marks" },
    { "<leader>fq",  "FzfLua quickfix",                                                                             "n", "FzfLua quickfix" },
    { "<leader>fv",  "FzfLua loclist",                                                                              "n", "FzfLua loclist" },
    { "<leader>fs",  "FzfLua spell_suggest",                                                                        "n", "FzfLua spelling suggestions" },
    { "<leader>f.",  "FzfLua lgrep_curbuf",                                                                         "n", "FzfLua fuzzy find in current buffer" },
    { "gd",          "FzfLua lsp_definitions jump1=true",                                                           "n", "FzfLua LSP go to definition" },
    { "gi",          "FzfLua lsp_implementations jump1=true",                                                       "n", "FzfLua LSP go to implementation" },
    { "gt",          "FzfLua lsp_typedefs jump1=true",                                                              "n", "FzfLua LSP go to type definition" },
    { "<leader>sl",  function() require('fzf-lua').complete_line({ search = vim.api.nvim_get_current_line() }) end, "n", "FzfLua complete line" },
    { "<C-x><C-l>",  function() require('fzf-lua').complete_line({ search = vim.api.nvim_get_current_line() }) end, "i", "FzfLua complete line" },
    { "<leader>sf",  function() require('fzf-lua').complete_path() end,                                             "n", "FzfLua complete path" },
    { "<C-x><C-f>",  function() require('fzf-lua').complete_path() end,                                             "i", "FzfLua complete path" },
  }),
  config = function()
    local actions = require("fzf-lua.actions")
    local path = require("fzf-lua.path")
    local fzf_utils = require("fzf-lua.utils")
    local quickfix = require('fzf-lua.providers.quickfix')
    local palette = require("catppuccin.palettes").get_palette()
    local colors = require("catppuccin.utils.colors")

    local darkerbg = colors.darken(colors.bg, 0.03, palette.mantle)

    vim.api.nvim_set_hl(0, "NormalFloat", { fg = palette.text, bg = darkerbg, force = true })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = palette.base, bg = darkerbg, force = true })
    vim.api.nvim_set_hl(0, "FloatTitle", { fg = palette.text, bg = darkerbg, force = true })

    vim.api.nvim_set_hl(0, "FloatPreviewNormal", { link = "Normal", force = true })
    vim.api.nvim_set_hl(0, "FloatPreviewTitle", { link = "FloatTitle", force = true })
    vim.api.nvim_set_hl(0, "FloatPreviewBorder", { link = "FloatBorder", force = true })

    vim.api.nvim_set_hl(0, "FzfLuaNormal", { link = "NormalFloat", force = true })
    vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder", force = true })
    vim.api.nvim_set_hl(0, "FzfLuaTitle", { link = "FloatTitle", force = true })
    vim.api.nvim_set_hl(0, "FzfLuaPreviewNormal", { link = "FloatPreviewNormal", force = true })
    vim.api.nvim_set_hl(0, "FzfLuaPreviewTitle", { link = "FloatPreviewTitle", force = true })
    vim.api.nvim_set_hl(0, "FzfLuaPreviewBorder", { link = "FloatPreviewBorder", force = true })

    vim.api.nvim_set_hl(0, "FzfCustomPromptPrefix", { fg = palette.mauve })
    vim.api.nvim_set_hl(0, "FzfCustomSelectionCaret", { fg = palette.mauve, force = true })
    vim.api.nvim_set_hl(0, "FzfCustomMultiSelection", { fg = palette.subtext0, force = true })
    vim.api.nvim_set_hl(0, "FzfCustomMatching", { fg = palette.red, force = true })
    vim.api.nvim_set_hl(0, "FzfCustomHeaderBind", { fg = palette.blue, force = true })
    vim.api.nvim_set_hl(0, "FzfCustomHeaderText", { fg = palette.peach, force = true })

    local function hl_validate(hl)
      return not fzf_utils.is_hl_cleared(hl) and hl or nil
    end

    local vertical_custom = {
      winopts = {
        preview = {
          layout = "vertical",
          vertical = "up:60%"
        }
      },
      fzf_opts = {
        ["--info"] = "inline-right",
        ["--layout"] = "default"
      }
    }
    local vertical_rev_custom = {
      winopts = {
        preview = {
          layout = "vertical",
          vertical = "down:60%"
        }
      },
      fzf_opts = {
        ["--info"] = "inline-right"
      }
    }
    local cursor_custom = {
      prompt = "",
      previewer = false,
      winopts = {
        relative = "cursor",
        width = 60,
        height = 6,
        row = 1,
        col = 1,
      },
      fzf_opts = {
        ["--padding"] = "0,1,1,1"
      }
    }

    require("fzf-lua").setup({
      hls           = {
        header_bind = hl_validate("FzfCustomHeaderBind"),
        header_text = hl_validate("FzfCustomHeaderText"),
      },
      fzf_colors    = {
        ["fg"] = { "fg", "FzfLuaNormal" },
        ["bg"] = { "bg", "FzfLuaNormal" },
        ["hl"] = { "fg", "FzfCustomMatching", "bold" },
        ["hl+"] = { "fg", "FzfCustomMatching", "bold" },
        ["info"] = { "fg", "FzfCustomMultiSelection" },
        ["border"] = { "fg", "FzfLuaBorder" },
        ["gutter"] = { "bg", "FzfLuaNormal" },
        ["prompt"] = { "fg", "FzfCustomPromptPrefix" },
        ["pointer"] = { "fg", "FzfCustomSelectionCaret" },
        ["marker"] = { "fg", "FzfCustomSelectionCaret" },
        ["header"] = { "fg", "FzfLuaTitle", "italic" },
        ["preview-bg"] = { "bg", "FzfLuaPreviewNormal" },
        ["preview-border"] = { "fg", "FzfLuaPreviewBorder" },
      },
      winopts       = {
        border = false,
        preview = {
          title = false,
          scrollbar = false
        }
      },
      fzf_opts      = {
        ["--info"] = "inline-right",
        ["--padding"] = "1",
        ["--wrap"] = true
      },
      files         = {
        fzf_opts = {
          ["--info"] = "inline-right"
        },
      },
      grep          = vertical_custom,
      diagnostics   = vertical_custom,
      buffers       = vertical_custom,
      quickfix      = vim.tbl_deep_extend('force', vertical_custom, {
        actions = {
          ["ctrl-x"] = function(selected, opts)
            local qlist = vim.tbl_filter(function(item)
              return not vim.tbl_contains(selected, function(v)
                local name = vim.fn.bufname(item.bufnr)
                local matched = name ..
                    ":" .. item.lnum .. ":" .. item.col .. ": " .. item.text
                return vim.endswith(vim.trim(v), vim.trim(matched))
              end, { predicate = true })
            end, vim.fn.getqflist())
            vim.fn.setqflist(qlist, 'r')
            quickfix.quickfix(opts)
          end
        }
      }),
      marks         = vertical_custom,
      jumps         = vertical_custom,
      complete_line = vertical_custom,
      complete_path = vertical_custom,
      git           = {
        status = vertical_custom,
        commits = vertical_custom,
        bcommits = vertical_custom,
        stash = vertical_custom,
      },
      spell_suggest = cursor_custom,
      lsp           = {
        code_actions = cursor_custom,
        diagnostics = vertical_custom,
        symbols = vertical_rev_custom,
      },
      keymap        = {
        builtin = {
          -- these are terminal maps
          ["<C-?>"] = "toggle-help",
          ["<C-f>"] = "toggle-fullscreen",
          ["<C-u>"] = "preview-half-page-up",
          ["<C-d>"] = "preview-half-page-down",
          ["<C-p>"] = "toggle-preview",
        },
        fzf = {
          ["ctrl-u"] = "preview-half-page-up",
          ["ctrl-d"] = "preview-half-page-down",
          ["ctrl-p"] = "toggle-preview",
        }
      },
      actions       = {
        files = {
          -- providers that inherit these actions:
          --   files, git_files, git_status, grep, lsp
          --   oldfiles, quickfix, loclist, tags, btags
          --   args
          -- default action opens a single selection
          -- or sends multiple selection to quickfix
          ["default"] = actions.file_edit_or_qf,
          ["ctrl-_"]  = actions.file_split,
          ["ctrl-v"]  = actions.file_vsplit, -- terminal maps <C-\> is taken
          ["ctrl-t"]  = actions.file_tabedit,
          ["ctrl-y"]  = function(selected, opts)
            vim.fn.setreg('+', path.entry_to_file(selected[1], opts).path)
          end,
          ["alt-q"]   = actions.file_sel_to_qf,
          ["alt-l"]   = actions.file_sel_to_ll,
        },
        buffers = {
          -- providers that inherit these actions:
          --   buffers, tabs, lines, blines
          ["default"] = actions.buf_edit_or_qf,
          ["ctrl-_"]  = actions.buf_split,
          ["ctrl-v"]  = actions.buf_vsplit, -- terminal maps <C-\> is taken
          ["ctrl-t"]  = actions.buf_tabedit,
          ["ctrl-y"]  = function(selected, opts)
            vim.fn.setreg('+', path.entry_to_file(selected[1], opts).path)
          end,
          ["alt-q"]   = actions.buf_sel_to_qf,
          ["alt-l"]   = actions.buf_sel_to_ll,
        }
      },
    })
    vim.cmd([[FzfLua register_ui_select]])
  end
}
