return function()
  local fzf_lua = require('fzf-lua')
  local files = require('fzf-lua.providers.files')
  local grep = require('fzf-lua.providers.grep')

  fzf_lua.fzf_exec("fd --type d --base-directory $dev --path-separator '' --max-depth 1 --prune", {
    prompt = "Development Projects> ",
    winopts = {
      width = 0.40,
      height = 0.40
    },
    fn_transform = fzf_lua.utils.ansi_codes.blue,
    actions = {
      ['default'] = function(selected)
        files.files({ cwd = "$dev/" .. selected[1] })
      end,
      ['ctrl-l'] = function(selected)
        grep.live_grep({ cwd = "$dev/" .. selected[1] })
      end,
      ['ctrl-d'] = function(selected)
        vim.cmd("cd $dev/" .. selected[1])
      end
    }
  })
end
