---@type LazyPluginSpec
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    {
      'nvim-treesitter/nvim-treesitter-context',
      config = true,
    },
    {
      'nvim-treesitter/playground',
      lazy = true,
    },
  },
  config = function()
    require('nvim-treesitter.configs').setup({
      modules = {},
      auto_install = true,
      ensure_installed = 'all',
      sync_install = false,
      ignore_install = { '' }, -- list of parsers to ignore installing
      playground = { enable = false },
      highlight = {
        enable = true, -- false will disable the whole extension
        disable = function(lang, buf) -- disable on large files
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.uv.fs_fstat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true, disable = { 'yaml' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          node_decremental = '<C-BS>',
          scope_incremental = false,
        },
      },
      textobjects = {
        lsp_interop = {
          enable = true,
          border = 'solid',
          floating_preview_opts = {},
          peek_definition_code = {
            ['<leader>df'] = '@function.outer',
            ['<leader>dF'] = '@class.outer',
          },
        },
        move = {
          enable = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']C'] = '@class.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[C'] = '@class.outer',
          },
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['ab'] = '@block.outer',
            ['ib'] = '@block.inner',
            ['aa'] = '@assignment.outer',
            ['ia'] = '@assignment.inner',
            ['ash'] = '@assignment.lhs',
            ['asl'] = '@assignment.rhs',
            ['ao'] = '@loop.outer',
            ['io'] = '@loop.inner',
          },
        },
      },
    })

    -- set treesitter folding
    vim.opt.foldlevel = 99
    vim.opt.foldnestmax = 20
    vim.opt.foldtext =
      [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.opt.foldenable = false

    -- bugfix folds not working after opening file from telescope: https://github.com/nvim-telescope/telescope.nvim/issues/699
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        if vim.bo.filetype ~= 'neo-tree' then
          vim.cmd('normal zx')
        end
      end,
    })
  end,
}
