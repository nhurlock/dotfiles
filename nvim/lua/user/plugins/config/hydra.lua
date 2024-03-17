return {
  "nvimtools/hydra.nvim",
  init = function()
    local Hydra = require('hydra')
    local window_swap = require('user.utilities').window_swap

    local function move_window(dir)
      return function()
        local fromwin = vim.api.nvim_get_current_win()
        local frombuf = vim.api.nvim_win_get_buf(fromwin)
        if vim.bo[frombuf].filetype == 'neo-tree' then
          return
        end
        local fromline = vim.fn.line('.')
        vim.cmd('wincmd ' .. dir)
        local towin = vim.api.nvim_get_current_win()
        local tobuf = vim.api.nvim_win_get_buf(towin)
        if vim.bo[tobuf].filetype == 'neo-tree' then
          vim.fn.win_gotoid(fromwin)
          return
        end
        local toline = vim.fn.line('.')
        if frombuf == tobuf and fromwin == towin then
          return
        end
        vim.cmd('buf +' .. toline .. ' ' .. tobuf)
        vim.api.nvim_win_call(fromwin, function()
          vim.cmd('buf +' .. fromline .. ' ' .. frombuf)
        end)
      end
    end

    Hydra({
      name = 'Window Adjustment',
      mode = 'n',
      body = '<C-w>a',
      config = {
        color = 'amaranth',
        hint = false,
        exit = false,
        invoke_on_body = true
      },
      heads = {
        { 'h',     '<C-w>h',                      { desc = 'Focus window left' } },
        { 'j',     '<C-w>j',                      { desc = 'Focus window below' } },
        { 'k',     '<C-w>k',                      { desc = 'Focus window above' } },
        { 'l',     '<C-w>l',                      { desc = 'Focus window right' } },
        { '<M-h>', '<cmd>vertical resize -3<cr>', { desc = 'Resize window width smaller' } },
        { '<M-j>', '<cmd>resize -3<cr>',          { desc = 'Resize window width height smaller' } },
        { '<M-k>', '<cmd>resize +3<cr>',          { desc = 'Resize window width height larger' } },
        { '<M-l>', '<cmd>vertical resize +3<cr>', { desc = 'Resize window width larger' } },
        { 'H',     move_window('h'),              { desc = 'Move window left' } },
        { 'J',     move_window('j'),              { desc = 'Move window below' } },
        { 'K',     move_window('k'),              { desc = 'Move window above' } },
        { 'L',     move_window('l'),              { desc = 'Move window right' } },
        { 'S',     window_swap,                   { desc = 'Swap window with another' } },
        { '<esc>', nil,                           { desc = 'Exit window adjustment', exit = true } },
      }
    })
  end
}
