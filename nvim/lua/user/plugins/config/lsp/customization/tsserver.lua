local create_user_command = vim.api.nvim_buf_create_user_command

local M = {
  Methods = {
    DEFINITION = "textDocument/definition",
    CODE_ACTION = "textDocument/codeAction",
    EXECUTE_COMMAND = "workspace/executeCommand",
    DID_CHANGE_WATCHED_FILES = "workspace/didChangeWatchedFiles"
  },
  TypescriptMethods = {
    RENAME = "_typescript.rename"
  },
  WorkspaceCommands = {
    APPLY_RENAME_FILE = "_typescript.applyRenameFile",
    GO_TO_SOURCE_DEFINITION = "_typescript.goToSourceDefinition"
  },
  SourceActions = {
    SORT_IMPORTS = "source.sortImports.ts",
    ORGANIZE_IMPORTS = "source.organizeImports.ts",
    ADD_MISSING_IMPORTS = "source.addMissingImports.ts",
    REMOVE_UNUSED_IMPORTS = "source.removeUnusedImports.ts",
    REMOVE_UNUSED = "source.removeUnused.ts",
    FIX_ALL = "source.fixAll.ts"
  }
}

local function resolve_handler(client, method)
  return client.handlers[method] or vim.lsp.handlers[method]
end

local function go_to_source_definition(client, bufnr)
  return function()
    local winnr = vim.api.nvim_get_current_win()
    local position_params = vim.lsp.util.make_position_params(winnr, client.offset_encoding)
    local request_ok = client.request(
      M.Methods.EXECUTE_COMMAND,
      {
        command = M.WorkspaceCommands.GO_TO_SOURCE_DEFINITION,
        arguments = { position_params.textDocument.uri, position_params.position }
      },
      function(...)
        local handler = resolve_handler(client, M.Methods.DEFINITION)
        if not handler then
          print("failed to go to source definition: could not resolve definition handler")
          return
        end
        local args = { ... }
        local res = args[2] or ({})
        if vim.tbl_isempty(res) then
          return client.request(M.Methods.DEFINITION, position_params, handler, bufnr)
        end
        handler(...)
      end
    )
    if not request_ok then
      print("failed to go to source definition: tsserver request failed")
    end
    return request_ok
  end
end

local function code_actions(client, bufnr, actions)
  return function(opts)
    local only = actions
    if not actions or #actions == 0 then
      only = client.server_capabilities.codeActionProvider.codeActionKinds
    end
    vim.lsp.buf.code_action({
      context = {
        only = only
      },
      apply = opts.bang == true
    })
    if opts.bang ~= true then return end
    local action_id = nil
    for id, request in pairs(client.requests) do
      if request.bufnr == bufnr and request.method == M.Methods.CODE_ACTION then
        action_id = id
        break
      end
    end
    local status, _ = vim.wait(5000, function()
      return action_id == nil or client.requests[action_id] == nil
    end, 50)
    if not status then
      print('code action request timeout')
    end
  end
end

local function handle_did_change_files(client, params)
  if not params or not params.changes then return false end
  local rename_changes = {}
  local deleted = false
  local created = false
  for _, change in ipairs(params.changes) do
    if change.type == vim.lsp.protocol.FileChangeType.Deleted then
      if created then
        table.insert(rename_changes, { sourceUri = change.uri, targetUri = created })
        created = false
      else
        deleted = change.uri
        created = false
      end
    elseif change.type == vim.lsp.protocol.FileChangeType.Created then
      if deleted then
        table.insert(rename_changes, { sourceUri = deleted, targetUri = change.uri })
        deleted = false
      else
        created = change.uri
        deleted = false
      end
    else
      deleted = false
      created = false
    end
  end
  for _, rename_change in ipairs(rename_changes) do
    vim.print(rename_change)
    client.request(M.Methods.EXECUTE_COMMAND, {
      command = M.WorkspaceCommands.APPLY_RENAME_FILE,
      arguments = {
        {
          sourceUri = rename_change.sourceUri,
          targetUri = rename_change.targetUri
        }
      }
    })
  end
end

M.on_attach = function(client, bufnr)
  create_user_command(bufnr, "TypescriptGoToSourceDefinition", go_to_source_definition(client, bufnr), {})
  create_user_command(bufnr, "TypescriptCodeActions", code_actions(client, bufnr), { bang = true })
  create_user_command(bufnr, "TypescriptSortImports",
    code_actions(client, bufnr, { M.SourceActions.SORT_IMPORTS }), { bang = true })
  create_user_command(bufnr, "TypescriptOrganizeImports",
    code_actions(client, bufnr, { M.SourceActions.ORGANIZE_IMPORTS }), { bang = true })
  create_user_command(bufnr, "TypescriptAddMissingImports",
    code_actions(client, bufnr, { M.SourceActions.ADD_MISSING_IMPORTS }), { bang = true })
  create_user_command(bufnr, "TypescriptRemoveUnusedImports",
    code_actions(client, bufnr, { M.SourceActions.REMOVE_UNUSED_IMPORTS }), { bang = true })
  create_user_command(bufnr, "TypescriptRemoveUnused",
    code_actions(client, bufnr, { M.SourceActions.REMOVE_UNUSED }), { bang = true })
  create_user_command(bufnr, "TypescriptFixAll",
    code_actions(client, bufnr, { M.SourceActions.FIX_ALL }), { bang = true })
  vim.keymap.set("n", "<leader>.", "<cmd>TypescriptCodeActions<cr>",
    { buffer = bufnr, silent = true, desc = "Typescript code actions" })
  vim.keymap.set("n", "<leader>gD", "<cmd>TypescriptGoToSourceDefinition<cr>",
    { buffer = bufnr, silent = true, desc = "Typescript go to source definition" })

  -- vim.lsp.handlers['client/registerCapability'](nil, {
  --   registrations = {
  --     {
  --       id = 'watchfiles-test-0',
  --       method = 'workspace/didChangeWatchedFiles',
  --       registerOptions = {
  --         watchers = {
  --           {
  --             globPattern = '**/**',
  --             kind = vim.lsp.protocol.WatchKind.Create + vim.lsp.protocol.WatchKind.Delete
  --           }
  --         }
  --       }
  --     }
  --   }
  -- }, {
  --   client_id = client.id,
  --   method = "client/registerCapability"
  -- })
  --
  -- local original_client_notify = client.notify
  -- client.notify = function(...)
  --   local args = { ... }
  --   if args[1] == M.Methods.DID_CHANGE_WATCHED_FILES then
  --     return handle_did_change_files(client, args[2])
  --   end
  --   original_client_notify(...)
  -- end
end

M.handlers = {
  [M.TypescriptMethods.RENAME] = function(_, res)
    if not type(res) == "table" and res.position ~= nil then
      return
    end
    local bufnr = 0
    local win = 0
    local pos = res.position
    local line = pos.line
    local character = pos.character
    local col = vim.str_byteindex(
      vim.api.nvim_buf_get_lines(bufnr, line, line + 1, true)[1],
      character,
      true
    )
    vim.api.nvim_win_set_cursor(win, { line + 1, col })
    vim.lsp.buf.rename()
    return res
  end
}

return M
