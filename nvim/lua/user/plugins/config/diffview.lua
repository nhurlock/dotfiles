local utils = require('user.utilities')

---@type LazyPluginSpec
return {
  'sindrets/diffview.nvim',
  cmd = {
    'DiffviewOpen',
    'DiffviewFileHistory',
  },
  keys = utils.lazy_maps({
    { '<leader>gv', 'DiffviewOpen', 'n', 'Git open diff' },
    { '<leader>gV', 'DiffviewClose', 'n', 'Git close diff' },
    { '<leader>gh', 'DiffviewFileHistory %', 'n', 'Git file history' },
    { '<leader>gf', 'DiffviewToggleFiles', 'n', 'Git files' },
  }),
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local actions = require('diffview.actions')

    require('diffview').setup({
      enhanced_diff_hl = true,
      hooks = {
        view_opened = function()
          actions.toggle_files()
        end,
        view_closed = function()
          if not vim.env.DIFFVIEW then
            return
          end
          vim.cmd.quit()
        end,
      },
    })
  end,
}
