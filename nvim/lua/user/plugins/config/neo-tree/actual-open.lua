local window_picker = require('user.utilities.window-picker')

local function open_in_new_window(winid, node_path, open_cmd)
  local target_winid = window_picker(winid, function(buf)
    return vim.bo[buf].filetype ~= "toggleterm"
  end)
  if not target_winid then
    return
  end

  local win_ids = vim.api.nvim_list_wins()
  local create_new_window = #win_ids == 1
  local new_window_side = "aboveleft"

  local cmd
  if create_new_window or (open_cmd and string.match(open_cmd, "split")) then
    cmd = string.format("%s %s %s", new_window_side, open_cmd or "vsplit", node_path)
  else
    cmd = string.format("edit %s", node_path)
  end

  if target_winid ~= -1 then
    vim.api.nvim_set_current_win(target_winid)
  end

  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, cmd)
end

return function(state, path, open_cmd)
  local fs = require("neo-tree.sources.filesystem")
  local utils = require("neo-tree.utils")
  local node_exists, node = pcall(function() return state.tree:get_node() end)

  -- handle directory toggle
  if node_exists and node.type == "directory" then
    return fs.toggle_directory(state, node, nil, false, false)
  end

  if not node_exists and not path then return end

  local found_buf = utils.find_buffer_by_name(node.path or path)

  -- handle case when buf is already open in a win, otherwise open new win
  if found_buf ~= -1 and vim.api.nvim_buf_is_loaded(found_buf) and vim.fn.bufwinid(found_buf) ~= -1 then
    vim.api.nvim_set_current_win(vim.fn.bufwinid(found_buf))
  else
    open_in_new_window(state.winid, node.path, open_cmd)
  end
end
