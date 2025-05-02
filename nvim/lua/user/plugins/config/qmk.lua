---@module 'qmk'

---@type LazyPluginSpec
return {
  'codethread/qmk.nvim',
  init = function()
    local group = vim.api.nvim_create_augroup('qmk', {})

    vim.api.nvim_create_autocmd('BufEnter', {
      desc = 'ai03 Altair',
      group = group,
      pattern = '*ai03/altair/*/keymap.c',
      callback = function()
        require('qmk').setup({
          name = 'LAYOUT',
          variant = 'qmk',
          comment_preview = {
            keymap_overrides = {},
          },
          layout = {
            'x x x x x x x _ x x x x x x x',
            'x x x x x x x _ x x x x x x x',
            'x x x x x x x _ x x x x x x x',
            'x x x x x x x _ x x x x x x x',
            '_ _ _ x x x x _ x x x x _ _ _',
          },
        })
      end,
    })

    vim.api.nvim_create_autocmd('BufEnter', {
      desc = 'Corne',
      group = group,
      pattern = '*corne.keymap',
      callback = function()
        require('qmk').setup({
          name = 'corne',
          variant = 'zmk',
          comment_preview = {
            keymap_overrides = {},
          },
          layout = {
            'x x x x x x _ x x x x x x',
            'x x x x x x _ x x x x x x',
            'x x x x x x _ x x x x x x',
            '_ _ _ x x x _ x x x _ _ _',
          },
        })
      end,
    })
  end,
}
