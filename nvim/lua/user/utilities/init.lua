local M = {}

M.lazy_map = function(mapping, action, modes, desc)
  if type(action) == 'string' then
    action = '<cmd>' .. action .. '<cr>'
  end
  return { mapping, action, mode = modes, silent = true, noremap = true, desc }
end

M.lazy_maps = function(maps)
  return vim.tbl_map(function(map)
    return M.lazy_map(unpack(map))
  end, maps)
end

M.get_visual_selection = function()
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' and mode ~= '' then
    return nil
  end
  vim.cmd('normal! "xy')
  return vim.fn.getreg('x')
end

M.run_in_node = function()
  local selection_text = M.get_visual_selection()
  local current_line = vim.api.nvim_get_current_line()
  if (not selection_text or #selection_text == 0) and (not current_line or #current_line == 0) then
    return nil
  end
  local command = 'node -e "(async () => '
    .. (selection_text or current_line):gsub('[\\"]', '\\%1')
    .. ')().then(console.log)"'
  local node_output = vim.fn.system(command)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  local prefix_command = 'S'
  if selection_text then
    prefix_command = 'gvdi'
  end
  vim.api.nvim_input(prefix_command .. vim.trim(node_output) .. '<esc>')
end

M.window_picker = require('user.utilities.window-picker')

M.window_swap = function()
  local fromwin = vim.fn.win_getid()
  local towin = M.window_picker(fromwin)
  if fromwin == nil or towin == nil then
    return
  end
  local frombuf = vim.api.nvim_win_get_buf(fromwin)
  if vim.bo[frombuf].filetype == 'neo-tree' then
    return
  end
  local fromline = vim.fn.line('.')
  vim.fn.win_gotoid(towin)
  local tobuf = vim.api.nvim_win_get_buf(towin)
  local toline = vim.fn.line('.')
  vim.cmd('buf +' .. fromline .. ' ' .. frombuf)
  vim.api.nvim_win_call(fromwin, function()
    vim.cmd('buf +' .. toline .. ' ' .. tobuf)
  end)
end

return M
