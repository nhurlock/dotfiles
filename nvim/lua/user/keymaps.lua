local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
local utilities = require('user.utilities')

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c"

local with_desc = function(mopts, desc)
  return vim.tbl_extend('force', mopts, { desc = desc })
end

keymap('', '<space>', '<nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- neovide-specific keymaps
if vim.g.neovide then
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    vim.cmd.redraw({ bang = true })
  end
  keymap('n', '<D-=>', function()
    change_scale_factor(1.10)
  end)
  keymap('n', '<D-->', function()
    change_scale_factor(1 / 1.10)
  end)
  keymap({ 'n', 'v', 's', 'x', 'o', 'i', 'l', 'c', 't' }, '<D-v>', function()
    vim.api.nvim_paste(vim.fn.getreg('+'), true, -1)
  end)
end

-- easier window resize
keymap('', '<M-left>', '<cmd>vertical resize -3<cr>', with_desc(opts, 'Resize window width smaller'))
keymap('', '<M-right>', '<cmd>vertical resize +3<cr>', with_desc(opts, 'Resize window width larger'))
keymap('', '<M-up>', '<cmd>resize +3<cr>', with_desc(opts, 'Resize window height larger'))
keymap('', '<M-down>', '<cmd>resize -3<cr>', with_desc(opts, 'Resize window height smaller'))

-- easier vert/horiz window swap
keymap('', '<leader>th', '<C-w>t<C-w>H', with_desc(opts, 'Swap window to horizontal split'))
keymap('', '<leader>tk', '<C-w>t<C-w>K', with_desc(opts, 'Swap window to vertical split'))

-- window mappings to mirror terminal splits
keymap('n', '<C-w>-', '<cmd>split<cr>', with_desc(opts, 'Create horizontal split'))
keymap('n', '<C-w>\\', '<cmd>vsplit<cr>', with_desc(opts, 'Create vertical split'))
keymap('n', '<C-w>c', '<cmd>vsplit | enew<cr>', with_desc(opts, 'Create vertical split with new buffer'))
keymap('n', '<C-w>x', '<cmd>bdelete<cr>', with_desc(opts, 'Delete current buffer'))

-- window swap
keymap('n', '<C-w>s', utilities.window_swap, with_desc(opts, 'Swap window with another'))

-- tab mappings
keymap('n', '<C-t>h', '<cmd>tabprev<cr>', with_desc(opts, 'Prev tab'))
keymap('n', '<C-t>l', '<cmd>tabnext<cr>', with_desc(opts, 'Next tab'))
keymap('n', '<C-t>c', '<cmd>tab split<cr>', with_desc(opts, 'Create tab'))
keymap('n', '<C-t>x', '<cmd>tabclose<cr>', with_desc(opts, 'Close tab'))
keymap('n', '<C-t>X', '<cmd>tabonly<cr>', with_desc(opts, 'Close other tabs'))

-- replace word under cursor
keymap(
  'n',
  '<leader>re',
  ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<left><left><left><left>',
  with_desc(opts, 'Replace word under cursor')
)

-- pathing
keymap('n', '<leader>xc', function()
  local file = vim.fn.expand('%:.')
  local line = vim.fn.line('.')
  vim.fn.setreg('+', file .. ':' .. line)
end, with_desc(opts, 'Copy current file and line number'))
keymap('n', '<leader>xo', function()
  pcall(function()
    local paste = vim.fn.getreg('+')
    if paste == nil then
      return
    end
    local result = vim.split(paste, ':', { trimempty = true })
    if #result ~= 2 then
      return
    end
    local exists = vim.fn.filereadable(result[1])
    if exists == nil or exists == false then
      return
    end
    local command = 'edit +' .. result[2] .. ' ' .. result[1]
    vim.cmd(command)
  end)
end, with_desc(opts, 'Go to file and line number in copy register'))

-- word wrap movement
keymap('n', 'j', [[(v:count > 1 ? "m`" . v:count : "g") . "j"]], { expr = true })
keymap('n', 'k', [[(v:count > 1 ? "m`" . v:count : "g") . "k"]], { expr = true })

-- clear search highlight on esc
keymap('n', '<esc>', '<esc><cmd>noh<cr>', with_desc(opts, 'Escape and clear highlight'))

-- stay in visual mode while changing indentation
keymap('v', '<', '<gv', with_desc(opts, 'Visual indent shift left'))
keymap('v', '>', '>gv', with_desc(opts, 'Visual indent shift right'))

-- center while jumping
keymap('n', '<C-d>', '<C-d>zz', with_desc(opts, 'Jump down and center'))
keymap('n', '<C-u>', '<C-u>zz', with_desc(opts, 'Jump up and center'))

-- paste over but keep original in paste buffer
keymap('x', '<leader>p', '"_dP', with_desc(opts, 'Paste and keep in paste register'))

-- yank into system clipboard
keymap('n', '<leader>y', '"+y', with_desc(opts, 'Yank to system clipboard'))
keymap('n', '<leader>Y', '"+Y', with_desc(opts, 'Yank line to system clipboard'))
keymap('v', '<leader>y', '"+y', with_desc(opts, 'Yank selection to system clipboard'))

-- search within visual selection
keymap('x', '/', '<esc>/\\%V', with_desc(opts, 'Search within visual selection'))

-- lists
keymap('n', '<leader>xl', function()
  pcall(vim.cmd.lopen)
end, with_desc(opts, 'Open location list'))
keymap('n', '<leader>xq', function()
  pcall(vim.cmd.copen)
end, with_desc(opts, 'Open quickfix list'))

-- tab rotate
keymap('n', '[t', vim.cmd.tabprev, with_desc(opts, 'Go to prev tab'))
keymap('n', ']t', vim.cmd.tabnext, with_desc(opts, 'Go to next next'))

-- no upper Q
keymap('n', 'Q', '<nop>', opts)

-- run line as a command
keymap('n', '<leader>sh', '!!$SHELL<cr>', with_desc(opts, 'Run line as shell command'))

-- run line or selection in node
keymap({ 'n', 'v' }, '<leader>rin', utilities.run_in_node, with_desc(opts, 'Run line or selection in Node'))

-- terminal keymaps
keymap('t', '<C-q>', '<esc>', with_desc(opts, 'Terminal normal mode'))
keymap('t', '<esc>', '<C-\\><C-n>', with_desc(opts, 'Terminal escape'))
keymap('t', '<C-w>h', '<C-\\><C-n><C-W>h', with_desc(opts, 'Terminal focus window left'))
keymap('t', '<C-w>j', '<C-\\><C-n><C-W>j', with_desc(opts, 'Terminal focus window below'))
keymap('t', '<C-w>k', '<C-\\><C-n><C-W>k', with_desc(opts, 'Terminal focus window above'))
keymap('t', '<C-w>l', '<C-\\><C-n><C-W>l', with_desc(opts, 'Terminal focus window right'))
keymap('t', '<S-BS>', '<BS>', opts)

-- relative line number toggle
keymap({ 'n', 'v' }, '<leader>l', function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, with_desc(opts, 'Toggle relative line numbers'))

-- logical next/prev search result
keymap('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result' })
keymap({ 'x', 'o' }, 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
keymap('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev search result' })
keymap({ 'x', 'o' }, 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

-- undo breaks
for _, char in pairs({ ',', '.', ';', '/', '<bslash>', '<bar>' }) do
  keymap('i', char, char .. '<c-g>u', opts)
end

-- textobjects - line
keymap('x', 'il', 'g_o^', opts)
keymap('o', 'il', '<cmd>normal vil<cr>', opts)
keymap('x', 'al', '$o0', opts)
keymap('o', 'al', '<cmd>normal val<cr>', opts)

-- textobjects - special chars
for _, char in pairs({ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' }) do
  keymap('x', 'i' .. char, 'T' .. char .. 'ot' .. char, opts)
  keymap('o', 'i' .. char, '<cmd>normal vi' .. char .. '<cr>', opts)
  keymap('x', 'a' .. char, 'F' .. char .. 'of' .. char, opts)
  keymap('o', 'a' .. char, '<cmd>normal va' .. char .. '<cr>', opts)
end

-- textobjects - document
keymap('x', 'ad', '0ggoG$', opts)
keymap('o', 'ad', '<cmd>normal vad<cr>', opts)
