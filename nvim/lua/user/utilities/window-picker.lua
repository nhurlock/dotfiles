local window_picker_chars = "asdfqwerzxcvjklmiuopghtybn"

local function usable_win_ids(winid, filter)
  local tabpage = vim.api.nvim_get_current_tabpage()
  local win_ids = vim.api.nvim_tabpage_list_wins(tabpage)
  local usable = {}
  local unusable = {}

  for _, id in ipairs(win_ids) do
    local win_config = vim.api.nvim_win_get_config(id)
    local buf = vim.api.nvim_win_get_buf(id)
    local buf_filetype = vim.bo[buf].filetype
    local buf_type = vim.bo[buf].buftype
    local buf_name = vim.fn.bufname(buf)
    if buf_name ~= nil and id ~= winid and
        win_config.focusable and
        not win_config.external and
        ((buf_type ~= "nofile" and buf_type ~= "prompt") or
          (buf_filetype == "starter")) and (filter == nil or filter(buf)) then
      table.insert(usable, id)
    else
      table.insert(unusable, id)
    end
  end

  return usable, unusable
end

local function apply_changes(id, new_statusline, new_winhl)
  local ok_status, statusline = pcall(vim.api.nvim_get_option_value, "statusline", { win = id })
  local ok_hl, winhl = pcall(vim.api.nvim_get_option_value, "winhl", { win = id })

  if new_statusline ~= nil then
    -- clear statusline for windows not selectable
    vim.api.nvim_set_option_value("statusline", new_statusline, { win = id })
  end
  if new_winhl ~= nil then
    -- clear statusline for windows not selectable
    vim.api.nvim_set_option_value("winhl", new_winhl, { win = id })
  end

  return {
    statusline = ok_status and statusline or "",
    winhl = ok_hl and winhl or "",
  }
end

local function reset_changes(id, old_opts)
  if old_opts == nil then
    return
  end
  for opt, value in pairs(old_opts) do
    pcall(vim.api.nvim_set_option_value, opt, value, { win = id })
  end
end

local function get_user_input_char()
  local c = vim.fn.getchar()
  while type(c) ~= "number" do
    c = vim.fn.getchar()
  end
  return vim.fn.nr2char(c)
end

local function pick_win_id(winid, filter)
  local selectable, not_selectable = usable_win_ids(winid, filter)

  if #selectable == 0 then
    return -1
  end
  -- no need to pick a window if there's only one to select
  if #selectable == 1 then
    return selectable[1]
  end

  local lualine = require('lualine')

  -- temporarily hide lualine so it doesn't overwrite our statusline
  lualine.hide({ place = { 'statusline' }, unhide = false })

  local i = 1
  local win_opts = {}
  local win_map = {}
  local laststatus = vim.o.laststatus
  vim.o.laststatus = 2

  -- adjust statusline of windows for picker
  for _, id in ipairs(selectable) do
    -- apply a char to the win for user selection
    local char = window_picker_chars:sub(i, i)
    win_map[char] = id

    win_opts[id] = apply_changes(id, "%=" .. char .. "%=",
      "StatusLine:NeoTreeWindowPicker,StatusLineNC:NeoTreeWindowPicker")

    i = i + 1
    if i > #window_picker_chars then
      break
    end
  end
  if laststatus == 3 then
    for _, id in ipairs(not_selectable) do
      win_opts[id] = apply_changes(id, " ")
    end
  end

  -- read input for selected char
  vim.cmd("redraw")
  local _, resp = pcall(get_user_input_char)
  resp = (resp or ""):lower()

  -- restore window options
  for _, id in ipairs(selectable) do
    reset_changes(id, win_opts[id])
  end
  if laststatus == 3 then
    for _, id in ipairs(not_selectable) do
      reset_changes(id, win_opts[id])
    end
  end

  -- restore laststatus
  vim.o.laststatus = laststatus

  -- restore lualine
  lualine.hide({ place = { 'statusline' }, unhide = true })

  -- ensure user selected a char assigned to a win
  if not vim.tbl_contains(vim.split(window_picker_chars, ""), resp) then
    return
  end

  return win_map[resp]
end

return function(winid, filter)
  local target_winid = pick_win_id(winid, filter)
  if target_winid == nil then return end
  return target_winid
end
