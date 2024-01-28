local autocmd = vim.api.nvim_create_autocmd

-- auto delete buffers when there have been no changes
autocmd("BufEnter", {
  callback = function(opts)
    if vim.b[opts.buf].is_unchanged == nil then
      vim.b[opts.buf].is_unchanged = true
    end
  end
})
autocmd("BufModifiedSet", {
  callback = function(opts)
    vim.b[opts.buf].is_unchanged = false
  end
})
autocmd("BufWinLeave", {
  callback = function(opts)
    if vim.b[opts.buf].is_unchanged then
      vim.cmd [[set nobuflisted]]
    end
  end
})

-- always default to insert mode when entering a git commit
autocmd("BufEnter", {
  pattern = "COMMIT_EDITMSG",
  command = "startinsert"
})

-- always default to insert mode when entering a terminal
autocmd("TermOpen", {
  pattern = "term://*",
  command = "startinsert"
})

-- allow esc key in lazygit, use <C-q> instead
autocmd("TermEnter", {
  pattern = "term://*lazygit*toggleterm#*",
  callback = function()
    vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { noremap = true, silent = true, buffer = true })
    vim.keymap.set("t", "<esc>", "<esc>", { noremap = true, silent = true, buffer = true })
  end
})

-- auto close terminal when process exits
autocmd("TermClose", {
  pattern = "term://*",
  callback = function(opts)
    vim.schedule(function()
      pcall(vim.api.nvim_buf_delete, opts.buf, {})
    end)
  end
})

-- highlight text yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Search" })
  end
})
