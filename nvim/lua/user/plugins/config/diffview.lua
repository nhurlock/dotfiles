local utils = require('user.utilities')

---@type LazyPluginSpec
return {
  'sindrets/diffview.nvim',
  lazy = vim.env.DIFFVIEW ~= 'true',
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
  config = function()
    local actions = require('diffview.actions')

    require('diffview').setup({
      enhanced_diff_hl = true,
      hooks = {
        view_opened = function()
          actions.toggle_files()
          if vim.env.DIFFVIEW == 'true' then
            vim.cmd('tabo')
          end
        end,
        view_closed = function()
          if vim.env.DIFFVIEW == 'true' then
            vim.cmd.quitall()
          end
        end,
      },
    })
  end,
}
