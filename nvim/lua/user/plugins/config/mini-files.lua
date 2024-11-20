local utils = require("user.utilities")

local toggle_minifiles = function(...)
  local minifiles = require("mini.files")
  if not minifiles.close() then
    minifiles.open(...)
  end
end

---@type LazyPluginSpec
return {
  "echasnovski/mini.files",
  version = false,
  lazy = false,
  keys = utils.lazy_maps({
    { "<leader>v", function() toggle_minifiles(nil, false) end, "n", "MiniFiles open" },
    { "<leader>V", function()
      local bufname = vim.api.nvim_buf_get_name(0)
      if vim.bo.buftype == "nofile" then
        return toggle_minifiles(nil, false)
      end
      return toggle_minifiles(bufname)
    end, "n", "MiniFiles open current file" },
  }),
  opts = {
    mappings = {
      close       = 'q',
      go_in       = '',
      go_in_plus  = '',
      go_out      = 'h',
      go_out_plus = '',
      reset       = '<BS>',
      reveal_cwd  = '@',
      show_help   = 'g?',
      synchronize = '=',
      trim_left   = '<',
      trim_right  = '>',
    }
  },
  config = function(_, opts)
    local minifiles = require("mini.files")
    minifiles.setup(opts)

    local show_dotfiles = true

    local filter_show = function() return true end

    local filter_hide = function(fs_entry)
      return not vim.startswith(fs_entry.name, '.')
    end

    local toggle_dotfiles = function()
      show_dotfiles = not show_dotfiles
      local new_filter = show_dotfiles and filter_show or filter_hide
      minifiles.refresh({ content = { filter = new_filter } })
    end

    local actual_open = function(split, vertical)
      local content = minifiles.get_fs_entry()
      if content == nil then return end
      if content.fs_type == "directory" then
        return minifiles.go_in({})
      end
      local chosen = utils.window_picker()
      if chosen ~= nil and chosen ~= -1 then
        minifiles.close()
        vim.fn.win_gotoid(chosen)
        if split then
          if vertical then
            vim.cmd.vsplit(content.path)
          else
            vim.cmd.split(content.path)
          end
        else
          vim.cmd.edit(content.path)
        end
      end
    end

    local set_cwd = function()
      local content = minifiles.get_fs_entry()
      if content == nil then return end
      if content.fs_type == "directory" then
        return vim.fn.chdir(content.path)
      end
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(event)
        local buf_id = event.data.buf_id
        vim.keymap.set("n", "<C-=>", set_cwd, { buffer = buf_id })
        vim.keymap.set("n", "<C-h>", toggle_dotfiles, { buffer = buf_id })
        vim.keymap.set("n", "l", function() actual_open(false) end, { buffer = buf_id })
        vim.keymap.set("n", "\\", function() actual_open(true, true) end, { buffer = buf_id })
        vim.keymap.set("n", "-", function() actual_open(true, false) end, { buffer = buf_id })
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionRename",
      callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
      end,
    })
  end
}
