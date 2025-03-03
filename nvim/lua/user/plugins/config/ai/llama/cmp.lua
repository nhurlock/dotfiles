--- @module 'blink.cmp'
--- @class blink.cmp.Source
local source = {}

if vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = 'BlinkCmpItemKindLlama' })) then
  vim.api.nvim_set_hl(0, 'BlinkCmpItemKindLlama', { link = 'BlinkCmpItemKind' })
end

function source.new()
  return setmetatable({}, { __index = source })
end

---@param result string | nil
---@param ctx blink.cmp.Context
---@param callback fun(response?: blink.cmp.CompletionResponse)
function handle_source_callback(result, ctx, callback)
  ---@type blink.cmp.CompletionResponse
  local opts = {
    items = {},
    is_incomplete_backward = true,
    is_incomplete_forward = true
  }

  if not result or #vim.trim(result) == 0 then
    return callback(opts)
  end

  local full_line = vim.api.nvim_get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local prefix = full_line:sub(0, cursor[2])
  local suffix = full_line:sub(cursor[2] + 1)
  local line = prefix .. result
  local label = vim.trim(line)

  local range_end = #full_line + 1
  if vim.endswith(result, suffix) then
    range_end = cursor[2]
    result = result:sub(0, #result - #suffix)
  end

  opts.items = {
    {
      label = label,
      kind = vim.lsp.protocol.CompletionItemKind.Text,
      kind_hl = 'BlinkCmpItemKindLlama',
      textEdit = {
        newText = result,
        range = {
          start = { line = cursor[1] - 1, character = cursor[2] },
          ['end'] = { line = cursor[1] - 1, character = range_end }
        }
      },
      documentation = {
        kind = "markdown",
        value = "```" .. vim.bo[ctx.bufnr].filetype .. "\n" .. label .. "\n```"
      }
    }
  }
  return callback(opts)
end

function source:get_completions(ctx, callback)
  local group = vim.api.nvim_create_augroup("LlamaFimResults", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    pattern = "LlamaFimResults",
    group = group,
    once = true,
    callback = function()
      handle_source_callback(vim.fn.join(vim.call("llama#fim_results"), "\n"), ctx, callback)
    end
  })

  vim.call("llama#fim_cancel")
  vim.call("llama#fim", true, true)

  return function()
    vim.call("llama#fim_cancel")
    vim.api.nvim_clear_autocmds({ group = group })
  end
end

function source:execute(_, _, callback)
  callback()
end

return source
