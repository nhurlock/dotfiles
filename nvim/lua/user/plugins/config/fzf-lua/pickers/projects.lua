local function projects(dir)
  if not dir then
    dir = '$dev'
  end
  ---@type string|nil
  local parent = vim.fn.fnamemodify(dir, ':h')
  if parent == '.' then
    parent = nil
  end

  local prompt_suffix = ''
  if dir ~= '$dev' then
    prompt_suffix = dir:gsub('^$dev/', '') .. ' '
  end

  local minifiles = require('mini.files')
  local fzf_lua = require('fzf-lua')
  local files = require('fzf-lua.providers.files')
  local grep = require('fzf-lua.providers.grep')

  fzf_lua.fzf_exec('fd --type d --base-directory ' .. dir .. " --path-separator '' --max-depth 1 --prune", {
    prompt = 'Development Projects> ' .. prompt_suffix,
    winopts = {
      width = 0.40,
      height = 0.40,
    },
    fn_transform = fzf_lua.utils.ansi_codes.blue,
    actions = {
      ['default'] = function(selected)
        files.files({ cwd = dir .. '/' .. selected[1] })
      end,
      ['ctrl-o'] = function(selected)
        minifiles.open(vim.fn.expand(dir .. '/' .. selected[1]))
      end,
      ['ctrl-u'] = function()
        projects(parent)
      end,
      ['ctrl-p'] = function(selected)
        projects(dir .. '/' .. selected[1])
      end,
      ['ctrl-l'] = function(selected)
        grep.live_grep({ cwd = dir .. '/' .. selected[1] })
      end,
      ['ctrl-d'] = function(selected)
        vim.cmd('cd ' .. dir .. '/' .. selected[1])
      end,
    },
  })
end

return projects
