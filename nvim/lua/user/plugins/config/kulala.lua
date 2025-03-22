---@type LazyPluginSpec
return {
  'mistweaverco/kulala.nvim',
  ft = { 'http', 'rest' },
  opts = {
    urlencode = 'skipencoded',
    ui = {
      icons = {
        inlay = {
          done = '✓',
          error = '✗',
          loading = '●',
        },
        textHighlight = 'Comment',
        lineHighlight = 'Normal',
      },
    },
    global_keymaps = {
      ['Send request'] = {
        '<leader>sr',
        function()
          require('kulala').run()
        end,
        ft = { 'http', 'rest' },
      },
      ['Send all requests'] = {
        '<leader>sa',
        function()
          require('kulala').run_all()
        end,
        ft = { 'http', 'rest' },
      },
      ['Replay the last request'] = {
        '<leader>sR',
        function()
          require('kulala').replay()
        end,
        ft = { 'http', 'rest' },
      },
      ['Copy as cURL'] = {
        '<leader>sc',
        function()
          require('kulala').copy()
        end,
        ft = { 'http', 'rest' },
      },
      ['Paste from curl'] = {
        '<leader>sC',
        function()
          require('kulala').from_curl()
        end,
        ft = { 'http', 'rest' },
      },
      ['Select environment'] = {
        '<leader>se',
        function()
          require('kulala').set_selected_env()
        end,
        ft = { 'http', 'rest' },
      },
    },
  },
}
