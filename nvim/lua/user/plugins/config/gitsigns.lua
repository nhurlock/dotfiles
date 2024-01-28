return {
  "lewis6991/gitsigns.nvim",
  keys = {
    { "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>", mode = { "n" }, silent = true, noremap = true, desc = "Git preview hunk" },
    { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>",          mode = { "n" }, silent = true, noremap = true, desc = "Git stage hunk" },
    { "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>",        mode = { "n" }, silent = true, noremap = true, desc = "Git stage buffer" },
    { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>",     mode = { "n" }, silent = true, noremap = true, desc = "Git undo stage hunk" },
    { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",          mode = { "n" }, silent = true, noremap = true, desc = "Git reset hunk" },
    { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>",        mode = { "n" }, silent = true, noremap = true, desc = "Git reset buffer" },
    { "<leader>gd", "<cmd>Gitsigns diffthis<cr>",            mode = { "n" }, silent = true, noremap = true, desc = "Git diff" },
    { "]g",         "<cmd>Gitsigns next_hunk<cr>",           mode = { "n" }, silent = true, noremap = true, desc = "Git next hunk" },
    { "[g",         "<cmd>Gitsigns prev_hunk<cr>",           mode = { "n" }, silent = true, noremap = true, desc = "Git prev hunk" },
  },
  lazy = false,
  opts = {
    signs = {
      add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter_opts = {
      relative_time = false,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    yadm = {
      enable = false,
    },
  }
}
