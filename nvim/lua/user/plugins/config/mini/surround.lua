---@type LazyPluginSpec
return {
  'nvim-mini/mini.surround',
  version = false,
  opts = {
    mappings = {
      add = 'ys', -- Add surrounding in Normal and Visual modes
      delete = 'ds', -- Delete surrounding
      replace = 'cs', -- Replace surrounding
      find = '', -- Find surrounding (to the right)
      find_left = '', -- Find surrounding (to the left)
      highlight = '', -- Highlight surrounding
      update_n_lines = '', -- Update `n_lines`

      suffix_last = 'N', -- Suffix to search with "prev" method
      suffix_next = 'n', -- Suffix to search with "next" method
    },
    search_method = 'cover_or_next',
  },
  init = function()
    -- remap adding surrounding to visual mode selection
    vim.keymap.set('x', 'S', ":<C-u>lua MiniSurround.add('visual')<CR>", { noremap = true })
  end,
}
