local utils = require('user.utilities')

local toggle_minifiles = function(...)
  local minifiles = require('mini.files')
  if not minifiles.close() then
    minifiles.open(...)
  end
end

---@type LazyPluginSpec
return {
  'echasnovski/mini.files',
  version = false,
  keys = utils.lazy_maps({
    {
      '<leader>v',
      function()
        toggle_minifiles(nil, false)
      end,
      'n',
      'MiniFiles open',
    },
    {
      '<leader>V',
      function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if vim.bo.buftype == 'nofile' then
          return toggle_minifiles(nil, false)
        end
        return toggle_minifiles(bufname)
      end,
      'n',
      'MiniFiles open current file',
    },
  }),
  opts = {
    mappings = {
      close = 'q',
      go_in = '',
      go_in_plus = '',
      go_out = '',
      go_out_plus = '',
      reset = '<BS>',
      reveal_cwd = '@',
      show_help = 'g?',
      synchronize = '=',
      trim_left = '<',
      trim_right = '>',
    },
  },
  config = function(_, opts)
    local minifiles = require('mini.files')
    minifiles.setup(opts)

    local show_dotfiles = true

    local filter_show = function()
      return true
    end

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
      if content == nil then
        return
      end
      if content.fs_type == 'directory' then
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
      if content == nil then
        return
      end
      if content.fs_type == 'directory' then
        return vim.fn.chdir(content.path)
      end
    end

    local function keymap_set(buf_id)
      return function(maps)
        for _, map in ipairs(maps) do
          vim.keymap.set(map[1], map[2], map[3], { buffer = buf_id })
        end
      end
    end

    local function keymap_del(buf_id)
      return function(maps)
        for _, map in ipairs(maps) do
          vim.keymap.del(map[1], map[2], { buffer = buf_id })
        end
      end
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(event)
        local buf_id = event.data.buf_id
        local keyset = keymap_set(buf_id)
        local keydel = keymap_del(buf_id)
        local default_in_out_maps = {
          { 'n', 'h', minifiles.go_out },
          {
            'n',
            'l',
            function()
              actual_open(false)
            end,
          },
        }
        local edit_in_out_maps = {
          {
            'n',
            '<C-j>',
            function()
              vim.fn.feedkeys('j', 'n')
            end,
          },
          {
            'n',
            '<C-k>',
            function()
              vim.fn.feedkeys('k', 'n')
            end,
          },
          { 'n', '<C-h>', minifiles.go_out },
          {
            'n',
            '<C-l>',
            function()
              actual_open(false)
            end,
          },
        }

        local edit_mode = false
        local function toggle_edit_mode()
          edit_mode = not edit_mode
          if edit_mode then
            keydel(default_in_out_maps)
            keyset(edit_in_out_maps)
          else
            keydel(edit_in_out_maps)
            keyset(default_in_out_maps)
          end
        end

        keyset(default_in_out_maps)
        keyset({
          { 'n', '<C-d>', set_cwd },
          { 'n', '<C-e>', toggle_edit_mode },
          { 'n', '<C-.>', toggle_dotfiles },
          {
            'n',
            '<C-\\>',
            function()
              actual_open(true, true)
            end,
          },
          {
            'n',
            '<C-->',
            function()
              actual_open(true, false)
            end,
          },
        })
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesActionRename',
      callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
      end,
    })
  end,
}
