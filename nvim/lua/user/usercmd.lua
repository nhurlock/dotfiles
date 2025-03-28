local usercmd = vim.api.nvim_create_user_command

local function lower_opt_bang(cmd)
  usercmd(cmd, function(opts)
    local command = string.lower(cmd)
    if opts.bang then
      command = command .. '!'
    end
    vim.cmd(command)
  end, { bang = true })
end

-- fix common capitalization misses
lower_opt_bang('Q')
lower_opt_bang('Qall')
lower_opt_bang('W')
lower_opt_bang('Wall')
lower_opt_bang('Wq')
lower_opt_bang('Wqall')

-- see :h terminal-scrollback-pager
usercmd('TermHl', function()
  -- remove things that would add left-side padding
  -- otherwise every line would be wrapped
  vim.opt.signcolumn = 'no'
  vim.opt.number = false
  vim.opt.relativenumber = false

  -- make yanks go to system clipboard
  vim.cmd('set clipboard+=unnamedplus')

  -- make q close the scrollback pager
  vim.keymap.set('n', 'q', '<cmd>q<cr>')

  local bufnr = vim.api.nvim_create_buf(false, true)
  local chan = vim.api.nvim_open_term(bufnr, {})
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  vim.api.nvim_chan_send(chan, table.concat(lines, '\n'))
  vim.api.nvim_buf_delete(0, { force = true })
  vim.api.nvim_win_set_buf(0, bufnr)

  -- has to be after setting buffer for some reason
  -- need to set scrolloff=0 so we can move into correct position
  -- reset if a scroll happens
  local orig_scrolloff = vim.opt.scrolloff:get()
  vim.opt.scrolloff = 0
  vim.api.nvim_create_autocmd('WinScrolled', {
    buffer = bufnr,
    once = true,
    callback = function()
      vim.wo.scrolloff = orig_scrolloff
    end,
  })

  -- move the buffer contents into the same view as the terminal was
  -- place the cursor where the cursor was
  vim.defer_fn(function()
    vim.fn.feedkeys(
      tonumber(vim.env.KITTY_SCROLLBACK_NVIM_INPUT_LN)
        .. 'Gzt'
        .. tonumber(vim.env.KITTY_SCROLLBACK_NVIM_CURSOR_LN) - 1
        .. 'j'
        .. tonumber(vim.env.KITTY_SCROLLBACK_NVIM_CURSOR_COL) - 1
        .. 'l'
    )
  end, 10)
end, { desc = 'Highlights ANSI termcodes in curbuf' })

if vim.env.KITTY_SCROLLBACK_NVIM == 'true' then
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    once = true,
    callback = function()
      vim.cmd('TermHl')
    end,
  })
end
