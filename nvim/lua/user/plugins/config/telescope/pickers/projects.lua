local telescope_ok, _ = pcall(require, 'telescope')
if not telescope_ok then
  return
end

local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local config = require('telescope.config').values
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local entry_display = require('telescope.pickers.entry_display')
local state = require("telescope.actions.state")

local project_root = "$dev"

local function get_projects()
  local results = {}
  for name, type in vim.fs.dir(project_root, { depth = 1 }) do
    if type == "directory" then
      table.insert(results, name)
    end
  end
  return results
end

local function create_finder()
  local results = get_projects()

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { remaining = true }
    }
  })

  local function make_display(entry)
    return displayer({ entry.name, { entry.value } })
  end

  return finders.new_table({
    results = results,
    entry_maker = function(entry)
      local name = vim.fn.fnamemodify(entry, ":t")
      return {
        display = make_display,
        name = name,
        value = entry,
        ordinal = name .. " " .. entry
      }
    end
  })
end

local function handle_git(project)
  local is_git_repo = false
  for _ in vim.fs.dir(project .. '/.git', { depth = 1 }) do
    is_git_repo = true
    break
  end
  if is_git_repo then
    builtin.git_files({
      cwd = project,
      mode = 'insert'
    })
  else
    builtin.find_files({
      cwd = project,
      mode = 'insert'
    })
  end
end

local function change_prompt(builtin_prompt)
  return function(bufnr)
    local selected_entry = state.get_selected_entry()
    actions.close(bufnr)
    if not selected_entry then return end
    local project = project_root .. '/' .. selected_entry.value
    if not builtin_prompt or builtin_prompt == "git_files" or not builtin[builtin_prompt] then
      handle_git(project)
    else
      builtin[builtin_prompt]({
        cwd = project,
        mode = 'insert'
      })
    end
  end
end

local function projects(opts)
  local themes = require('telescope.themes')
  local dropdown = themes.get_dropdown(opts or {})
  if dropdown == nil then
    return
  end
  pickers.new(dropdown, {
    prompt_title = 'Development Projects',
    finder = create_finder(),
    preview = false,
    sorter = config.generic_sorter(opts),
    attach_mappings = function(bufnr, map)
      map("i", "<C-f>", change_prompt('find_files'))
      map("i", "<C-l>", change_prompt('live_grep'))
      actions.select_default:replace(function()
        change_prompt('git_files')(bufnr)
      end)
      return true
    end
  }):find()
end

return projects
