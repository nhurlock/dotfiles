local mode_table = {
  ['n'] = 'N',            -- Normal
  ['no'] = 'NO',          -- Operator-pending
  ['nov'] = 'NOV',        -- Operator-pending (forced charwise |o_v|)
  ['noV'] = 'NOV-L',      -- Operator-pending (forced linewise |o_V|)
  ['noCTRL-V'] = 'NOV-B', -- Operator-pending (forced blockwise |o_CTRL-V|)
  ['niI'] = 'NI',         -- Normal using |i_CTRL-O| in |Insert-mode|
  ['niR'] = 'NIR',        -- Normal using |i_CTRL-O| in |Replace-mode|
  ['niV'] = 'NIV',        -- Normal using |i_CTRL-O| in |Virtual-Replace-mode|
  ['nt'] = 'NT',          -- Normal using |t_CTRL-Q| in |Terminal-mode|
  ['v'] = 'V',            -- Visual by character
  ['V'] = 'V-L',          -- Visual by line
  ['CTRL-V'] = 'V-B',     -- Visual blockwise
  ['s'] = 'S',            -- Select by character
  ['S'] = 'S-L',          -- Select by line
  ['CTRL-S'] = 'S-B',     -- Select blockwise
  ['i'] = 'I',            -- Insert
  ['ic'] = 'IC',          -- Insert mode completion |compl-generic|
  ['ix'] = 'IX',          -- Insert mode |i_CTRL-X| completion
  ['R'] = 'R',            -- Replace |R|
  ['Rc'] = 'RC',          -- Replace mode completion |compl-generic|
  ['Rv'] = 'RV',          -- Virtual Replace |gR|
  ['Rx'] = 'RX',          -- Replace mode |i_CTRL-X| completion
  ['c'] = 'C',            -- Command-line editing
  ['cv'] = 'CV',          -- Vim Ex mode |gQ|
  ['ce'] = 'CE',          -- Normal Ex mode |Q|
  ['r'] = 'R-P',          -- Hit-enter prompt
  ['rm'] = 'R-M',         -- The -- more -- prompt
  ['r?'] = 'R-?',         -- |:confirm| query of some sort
  [':!'] = 'SH',          -- Shell or external command is executing
  ['t'] = 'T',            -- Terminal mode: keys go to the job
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
  if recording_register == "" then
    return ""
  else
    return "@" .. recording_register
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
  local root = vim.fs.root(0, ".git")
  if root == nil then
    root = vim.fn.getcwd()
  end
  return vim.fn.fnamemodify(root, ':t')
end

-- extension formater for file encoding
local function fmt_encoding(ft)
  if ft == "utf-8" then
    return ""
  else
    return ft
  end
end

-- extension formater for file name
local function fmt_filename(fn)
  if fn:match("neo%-tree") then
    return ""
  elseif fn:match("lazygit") and fn:match("toggleterm") then
    return "Git"
  elseif fn:match("node") and fn:match("toggleterm") then
    return "Node"
  elseif fn:match("toggleterm") then
    return "Terminal"
  else
    return fn
  end
end

---@type LazyPluginSpec
return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    'AndreM222/copilot-lualine'
  },
  config = function()
    require("lualine").setup({
      options = {
        globalstatus = true,
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { mode },
        lualine_b = {
          show_root,
          { 'branch', icon = '' },
          'diff',
          'diagnostics'
        },
        lualine_c = {
          {
            'filetype',
            icon_only = true,
            separator = ''
          },
          {
            'filename',
            separator = '',
            newfile_status = false,
            symbols = {
              modified = '●',
              readonly = '',
              unnamed = '[No Name]',
              newfile = '[New]',
            },
            fmt = fmt_filename
          }
        },
        lualine_x = {
          show_macro_recording,
          search_results,
          {
            'encoding',
            fmt = fmt_encoding
          },
          {
            'fileformat',
            symbols = {
              unix = ''
            }
          }
        },
        lualine_y = {
          {
            'copilot',
            show_colors = true,
            symbols = {
              spinners = require("copilot-lualine.spinners").bouncing_bar
            }
          },
          'progress'
        },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      }
    })
  end
}
