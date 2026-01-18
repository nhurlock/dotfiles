---@type LazyPluginSpec
local text_objects = {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  init = function()
    vim.g.no_plugin_maps = true
  end,
  opts = {
    move = {
      set_jumps = true,
    },
    select = {
      lookahead = true,
    },
  },
  config = function(_, opts)
    require('nvim-treesitter-textobjects').setup(opts)
    local ts_move = require('nvim-treesitter-textobjects.move')
    local ts_repeat_move = require('nvim-treesitter-textobjects.repeatable_move')
    local ts_select = require('nvim-treesitter-textobjects.select')

    vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })

    local move_goto_next_start = {
      [']f'] = '@function.outer',
      [']c'] = '@class.outer',
    }
    for key, query in pairs(move_goto_next_start) do
      vim.keymap.set({ 'n', 'x', 'o' }, key, function()
        ts_move.goto_next_start(query)
        vim.cmd('normal! zz')
      end)
    end

    local move_goto_next_end = {
      [']F'] = '@function.outer',
      [']C'] = '@class.outer',
    }
    for key, query in pairs(move_goto_next_end) do
      vim.keymap.set({ 'n', 'x', 'o' }, key, function()
        ts_move.goto_next_end(query)
        vim.cmd('normal! zz')
      end)
    end

    local move_goto_prev_start = {
      ['[f'] = '@function.outer',
      ['[c'] = '@class.outer',
    }
    for key, query in pairs(move_goto_prev_start) do
      vim.keymap.set({ 'n', 'x', 'o' }, key, function()
        ts_move.goto_previous_start(query)
        vim.cmd('normal! zz')
      end)
    end

    local move_goto_prev_end = {
      ['[F'] = '@function.outer',
      ['[C'] = '@class.outer',
    }
    for key, query in pairs(move_goto_prev_end) do
      vim.keymap.set({ 'n', 'x', 'o' }, key, function()
        ts_move.goto_previous_end(query)
        vim.cmd('normal! zz')
      end)
    end

    local select_textobjects = {
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
    }
    for key, query in pairs(select_textobjects) do
      vim.keymap.set({ 'x', 'o' }, key, function()
        ts_select.select_textobject(query)
      end)
    end
  end,
}

---@type LazyPluginSpec
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  dependencies = {
    text_objects,
    { 'nvim-treesitter/nvim-treesitter-context', config = true },
  },
  init = function()
    local treesitter = require('nvim-treesitter')
    treesitter.setup({
      install_dir = vim.fn.stdpath('data') .. '/site',
    })
    treesitter.install({
      'vim',
      'c',
      'printf',
      'powershell',
      'xml',
      'css',
      'bash',
      'diff',
      'dockerfile',
      'graphql',
      'lua',
      'luap',
      'luadoc',
      'vim',
      'vimdoc',
      'typescript',
      'javascript',
      'jsx',
      'tsx',
      'jsdoc',
      'html',
      'http',
      'java',
      'javadoc',
      'json',
      'kitty',
      'mermaid',
      'nginx',
      'sql',
      'scss',
      'python',
      'csv',
      'vue',
      'gitignore',
      'gitcommit',
      'gitattributes',
      'git_config',
      'git_rebase',
      'go',
      'query',
      'toml',
      'yaml',
      'regex',
      'markdown',
      'markdown_inline',
    })

    local max_filesize = 100 * 1024 -- 100 KB
    local parsers = require('nvim-treesitter.parsers')

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local language = vim.treesitter.language.get_lang(args.match)
        if not parsers[language] then
          return
        end

        local ok, stats = pcall(vim.uv.fs_fstat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > max_filesize then
          return
        end

        treesitter.install({ language }):await(function(err)
          if err then
            return vim.notify('Treesitter failed to install parsers for: ' .. language .. ', Error: ' .. err)
          end

          vim.treesitter.start(args.buf)

          vim.wo[0][0].foldmethod = 'expr'
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'

          if language ~= 'yaml' then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end)
      end,
    })
  end,
}
