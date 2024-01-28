local usercmd = vim.api.nvim_create_user_command

local function lower_opt_bang(cmd)
  usercmd(cmd, function(opts)
    local command = string.lower(cmd)
    if opts.bang then
      command = command .. '!'
    end
    vim.cmd(command)
  end, { bang = true })
end

-- fix common capitalization misses
lower_opt_bang("Q")
lower_opt_bang("Qall")
lower_opt_bang("W")
lower_opt_bang("Wall")
lower_opt_bang("Wq")
lower_opt_bang("Wqall")
