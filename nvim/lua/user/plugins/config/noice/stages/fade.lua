local function has_tree_open()
  for _, id in ipairs(vim.api.nvim_list_wins()) do
    local win_ok, buf = pcall(vim.api.nvim_win_get_buf, id)
    if win_ok and vim.bo[buf].filetype == "neo-tree" then
      return id
    end
  end
  return nil
end

return function()
  local tree_offset = 0
  return {
    function(state)
      local stages_util = require("notify.stages.util")
      local tree = has_tree_open()
      if tree then
        tree_offset = vim.api.nvim_win_get_width(tree) + 1
      else
        tree_offset = 0
      end
      local next_height = state.message.height + 2
      local next_row = stages_util.available_slot(state.open_windows, next_height, stages_util.DIRECTION
        .TOP_DOWN)
      if not next_row then
        return nil
      end
      return {
        relative = "editor",
        anchor = "NE",
        width = state.message.width,
        height = state.message.height,
        col = vim.opt.columns:get() - tree_offset,
        row = next_row,
        border = "rounded",
        style = "minimal",
        opacity = 0,
      }
    end,
    function()
      return {
        opacity = { 100 },
        col = { vim.opt.columns:get() - tree_offset },
      }
    end,
    function()
      return {
        col = { vim.opt.columns:get() - tree_offset },
        time = true,
      }
    end,
    function()
      return {
        opacity = {
          0,
          frequency = 2,
          complete = function(cur_opacity)
            return cur_opacity <= 4
          end,
        },
        col = { vim.opt.columns:get() - tree_offset },
      }
    end,
  }
end
