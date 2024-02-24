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

-- special keys to support fzf
autocmd("TermEnter", {
  pattern = "term://*",
  callback = function(opts)
    if vim.bo[opts.buf].filetype == "fzf" then
      vim.keymap.set("t", "<C-h>", "<C-h>", { noremap = true, silent = true, buffer = true })
      vim.keymap.set("t", "<C-j>", "<C-j>", { noremap = true, silent = true, buffer = true })
      vim.keymap.set("t", "<C-k>", "<C-k>", { noremap = true, silent = true, buffer = true })
      vim.keymap.set("t", "<C-l>", "<C-l>", { noremap = true, silent = true, buffer = true })
      vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { noremap = true, silent = true, buffer = true })
    end
  end
})

-- auto close terminal when process exits
autocmd("TermClose", {
  pattern = "term://*",
  callback = function(opts)
    if vim.bo[opts.buf].filetype ~= "fzf" then
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, opts.buf, {})
      end)
    end
  end
})

-- highlight text yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Search" })
  end
})

-- start treesitter on help buffers
autocmd("FileType", {
  pattern = "help",
  callback = function(opts)
    vim.treesitter.start(opts.buf)
  end
})
