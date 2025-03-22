return function()
  local fzf_lua = require('fzf-lua')
  local ansi_codes = fzf_lua.utils.ansi_codes
  local fidget_history = require('fidget.notification').get_history()

  table.sort(fidget_history, function(a, b)
    return a.last_updated > b.last_updated
  end)

  local fzf_fidget_history = vim.tbl_map(function(item)
    return ansi_codes.blue(os.date('%Y-%m-%d %H:%M:%S', item.last_updated))
      .. ansi_codes.grey(' [' .. item.group_name .. '] ')
      .. item.message
  end, fidget_history)

  fzf_lua.fzf_exec(fzf_fidget_history, {
    prompt = 'Log History> ',
    winopts = {
      width = 0.40,
      height = 0.40,
    },
    fzf_opts = {
      ['--layout'] = 'reverse',
    },
  })
end
