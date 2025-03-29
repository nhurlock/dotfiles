local mode_table = {
  ['n'] = 'N', -- Normal
  ['no'] = 'NO', -- Operator-pending
  ['nov'] = 'NOV', -- Operator-pending (forced charwise |o_v|)
  ['noV'] = 'NOV-L', -- Operator-pending (forced linewise |o_V|)
  ['noCTRL-V'] = 'NOV-B', -- Operator-pending (forced blockwise |o_CTRL-V|)
  ['niI'] = 'NI', -- Normal using |i_CTRL-O| in |Insert-mode|
  ['niR'] = 'NIR', -- Normal using |i_CTRL-O| in |Replace-mode|
  ['niV'] = 'NIV', -- Normal using |i_CTRL-O| in |Virtual-Replace-mode|
  ['nt'] = 'NT', -- Normal using |t_CTRL-Q| in |Terminal-mode|
  ['v'] = 'V', -- Visual by character
  ['V'] = 'V-L', -- Visual by line
  ['CTRL-V'] = 'V-B', -- Visual blockwise
  ['s'] = 'S', -- Select by character
  ['S'] = 'S-L', -- Select by line
  ['CTRL-S'] = 'S-B', -- Select blockwise
  ['i'] = 'I', -- Insert
  ['ic'] = 'IC', -- Insert mode completion |compl-generic|
  ['ix'] = 'IX', -- Insert mode |i_CTRL-X| completion
  ['R'] = 'R', -- Replace |R|
  ['Rc'] = 'RC', -- Replace mode completion |compl-generic|
  ['Rv'] = 'RV', -- Virtual Replace |gR|
  ['Rx'] = 'RX', -- Replace mode |i_CTRL-X| completion
  ['c'] = 'C', -- Command-line editing
  ['cv'] = 'CV', -- Vim Ex mode |gQ|
  ['ce'] = 'CE', -- Normal Ex mode |Q|
  ['r'] = 'R-P', -- Hit-enter prompt
  ['rm'] = 'R-M', -- The -- more -- prompt
  ['r?'] = 'R-?', -- |:confirm| query of some sort
  [':!'] = 'SH', -- Shell or external command is executing
  ['t'] = 'T', -- Terminal mode: keys go to the job
}

-- replace termcodes
local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- custom extension to display current mode
local function mode()
  local curr_mode = vim.api.nvim_get_mode()['mode']:gsub('%' .. t('<C-V>'), 'CTRL-V'):gsub('%' .. t('<C-S>'), 'CTRL-S')
  if mode_table[curr_mode] ~= nil then
    return mode_table[curr_mode]
  end
  return curr_mode
end

-- custom extension to show macros when recording
local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == '' then
    return ''
  else
    return '@' .. recording_register
  end
end

-- custom extension to show search result counter
local function search_results()
  if vim.v.hlsearch == 1 then
    local ok, searchcount = pcall(vim.fn.searchcount)
    if ok and searchcount.total > 0 then
      return searchcount.current .. '/' .. searchcount.total
    end
  end
  return ''
end

-- custom extension to get the root
local function show_root()
  local root = vim.fs.root(0, '.git')
  if root == nil then
    root = vim.fn.getcwd()
  end
  return vim.fn.fnamemodify(root, ':t')
end

-- extension formater for file encoding
local function fmt_encoding(ft)
  if ft == 'utf-8' then
    return ''
  else
    return ft
  end
end

-- extension formater for file name
local function fmt_filename(fn)
  if fn:match('lazygit') and fn:match('toggleterm') then
    return 'Git'
  elseif fn:match('welcome') then
    return 'Welcome'
  elseif fn:match('node') and fn:match('toggleterm') then
    return 'Node'
  elseif fn:match('toggleterm') then
    return 'Terminal'
  elseif vim.bo.filetype == 'minifiles' then
    return 'Files'
  else
    return fn
  end
end

---@type LazyPluginSpec
return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'AndreM222/copilot-lualine',
    {
      'SmiteshP/nvim-navic',
      opts = function()
        local icons = require('mini.icons')
        return {
          highlight = true,
          separator = '  ',
          depth_limit_indicator = '…',
          icons = {
            File = icons.get('lsp', 'file') .. ' ',
            Module = icons.get('lsp', 'module') .. ' ',
            Namespace = icons.get('lsp', 'namespace') .. ' ',
            Package = icons.get('lsp', 'package') .. ' ',
            Class = icons.get('lsp', 'class') .. ' ',
            Method = icons.get('lsp', 'method') .. ' ',
            Property = icons.get('lsp', 'property') .. ' ',
            Field = icons.get('lsp', 'field') .. ' ',
            Constructor = icons.get('lsp', 'constructor') .. ' ',
            Enum = icons.get('lsp', 'enum') .. ' ',
            Interface = icons.get('lsp', 'interface') .. ' ',
            Function = icons.get('lsp', 'function') .. ' ',
            Variable = icons.get('lsp', 'variable') .. ' ',
            Constant = icons.get('lsp', 'constant') .. ' ',
            String = icons.get('lsp', 'string') .. ' ',
            Number = icons.get('lsp', 'number') .. ' ',
            Boolean = icons.get('lsp', 'boolean') .. ' ',
            Array = icons.get('lsp', 'array') .. ' ',
            Object = icons.get('lsp', 'object') .. ' ',
            Key = icons.get('lsp', 'key') .. ' ',
            Null = icons.get('lsp', 'null') .. ' ',
            EnumMember = icons.get('lsp', 'enummember') .. ' ',
            Struct = icons.get('lsp', 'struct') .. ' ',
            Event = icons.get('lsp', 'event') .. ' ',
            Operator = icons.get('lsp', 'operator') .. ' ',
            TypeParameter = icons.get('lsp', 'typeparameter') .. ' ',
          },
        }
      end,
    },
  },
  config = function()
    local palette = require('catppuccin.palettes').get_palette()
    local base_dim = palette.overlay0

    local filepath = {
      function()
        return vim.fn.fnamemodify(vim.fn.expand('%'), ':.:h')
      end,
      icon = { '', align = 'right', color = { fg = base_dim } },
      separator = '',
      padding = 1,
      color = { bg = 'NONE', fg = base_dim },
    }

    local filetype_filler = {
      function()
        return ' '
      end,
      padding = { left = 0, right = 0 },
      separator = '',
      color = { bg = 'NONE' },
      cond = function()
        local filetype = require('lualine.components.filetype')
        return filetype.status == ''
      end,
    }

    local filetype = {
      'filetype',
      icon_only = true,
      separator = '',
      padding = { left = 0, right = 0 },
      color = { bg = 'NONE' },
    }

    local filename = {
      'filename',
      separator = '',
      padding = { left = 0, right = 0 },
      newfile_status = false,
      symbols = {
        modified = '%#MiniIconsOrange#●',
        readonly = '%#MiniIconsRed#',
        unnamed = '[No Name]',
        newfile = '*',
      },
      fmt = fmt_filename,
      color = { bg = 'NONE', gui = 'bold' },
    }

    require('lualine').setup({
      options = {
        theme = 'catppuccin',
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_buftypes = { 'nofile', 'quickfix', 'prompt' },
        disabled_filetypes = {
          winbar = { 'toggleterm', 'ministarter' },
        },
      },
      sections = {
        lualine_a = { mode },
        lualine_b = {
          show_root,
          {
            'branch',
            icon = '',
            padding = { left = 0, right = 1 },
          },
          'diff',
          'diagnostics',
        },
        lualine_c = {
          filetype_filler,
          vim.tbl_extend('force', filetype, {
            padding = { left = 1, right = 0 },
          }),
          vim.tbl_extend('force', filename, {
            padding = { left = 0, right = 1 },
          }),
        },
        lualine_x = {
          show_macro_recording,
          search_results,
          {
            'encoding',
            fmt = fmt_encoding,
          },
          {
            'fileformat',
            symbols = {
              unix = '',
            },
          },
          {
            'copilot',
            cond = function()
              return vim.g.ai_provider == 'copilot'
            end,
            padding = { left = 1, right = 0 },
            show_colors = true,
            symbols = {
              spinners = require('copilot-lualine.spinners').bouncing_bar,
            },
          },
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          vim.tbl_extend('force', filepath, {
            cond = function()
              return vim.bo.buftype ~= 'nofile' and vim.bo.buftype ~= 'terminal'
            end,
          }),
          vim.tbl_extend('force', filetype, {
            cond = function()
              return vim.bo.buftype ~= 'nofile' and vim.bo.buftype ~= 'terminal'
            end,
          }),
          vim.tbl_extend('force', filename, {
            cond = function()
              return vim.bo.buftype ~= 'nofile' and vim.bo.buftype ~= 'terminal'
            end,
          }),
          {
            'navic',
            cond = function()
              return vim.bo.buftype ~= 'nofile' and vim.bo.buftype ~= 'terminal'
            end,
            color_correction = nil,
            navic_opts = nil,
            icon = { '', color = { fg = base_dim } },
            color = { bg = 'NONE' },
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          vim.tbl_extend('force', filepath, {
            cond = function()
              return vim.bo.buftype ~= 'nofile'
            end,
          }),
          vim.tbl_extend('force', filetype, {
            cond = function()
              return vim.bo.buftype ~= 'nofile'
            end,
          }),
          vim.tbl_extend('force', filename, {
            cond = function()
              return vim.bo.buftype ~= 'nofile'
            end,
          }),
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
