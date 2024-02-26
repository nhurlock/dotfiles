local M = {}

M.lazy_map = function(mapping, action, modes, desc)
  if type(action) == "string" then
    action = "<cmd>" .. action .. "<cr>"
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
  if mode ~= 'v' and mode ~= 'V' then return nil end
  local startpos = vim.fn.getpos(".")
  local endpos = vim.fn.getpos("v")
  local csrow = startpos[2]
  local cscol = startpos[3]
  local cerow = endpos[2]
  local cecol = endpos[3]
  if cerow < csrow then
    csrow, cerow, cscol, cecol = cerow, csrow, cecol, cscol
  elseif csrow == cerow and cecol < cscol then
    cscol, cecol = cecol, cscol - cecol + 1
  elseif csrow == cerow then
    cecol = cecol - cscol + 1
  end
  local lines = vim.fn.getline(csrow, cerow)
  lines[1] = string.sub(lines[1], cscol)
  lines[cerow - csrow + 1] = string.sub(lines[cerow - csrow + 1], 0, cecol)
  return table.concat(lines, '\n')
end

M.run_in_node = function()
  local selection_text = M.get_visual_selection()
  local current_line = vim.api.nvim_get_current_line()
  if not selection_text and not current_line then return nil end
  local command = 'node -e "(async () => ' ..
      (selection_text or current_line):gsub("[\\\"]", "\\%1") .. ')().then(console.log)"'
  local node_output = vim.fn.system(command)
  if vim.v.shell_error ~= 0 then return nil end
  local prefix_command = "0C"
  if selection_text then prefix_command = "c" end
  vim.api.nvim_input(prefix_command .. node_output:gsub("(.*)\n", "%1") .. "<esc>")
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
  vim.fn.win_gotoid(fromwin)
  vim.cmd('buf +' .. toline .. ' ' .. tobuf)
  vim.fn.win_gotoid(towin)
end

return M
