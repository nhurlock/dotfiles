local fzf_lua = require("fzf-lua")
local fzf_utils = require("fzf-lua.utils")
local actions = require("fzf-lua.actions")
local files = require("fzf-lua.providers.files")
local grep = require("fzf-lua.providers.grep")

local ffi = vim.F.npcall(require, "ffi")

local function posix_exec(cmd, ...)
	if type(cmd) ~= "string" or not ffi then
		return
	end
	local args = { ... }
	-- NOTE: must add NULL to mark end of the vararg
	table.insert(args, string.byte("\0"))
	ffi.C.execl(cmd, cmd, unpack(args))
	-- if `execl` succeeds we should never get here
	assert(false, string.format([[execl("%s",...) failed with error %d]], cmd, ffi.errno()))
end

local function quit()
	vim.cmd.quit()
end

local function expand_dev(path)
	local expanded_loc = path:gsub("^$dev/", vim.fn.expand("$dev") .. "/")
	return expanded_loc
end

local function cd(dir)
	return function(selected)
		vim.fn.chdir(expand_dev(dir .. "/" .. selected[1]))
	end
end

vim.api.nvim_set_hl(0, "FzfLuaNormal", { link = "NormalFloat", force = true })
vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder", force = true })
vim.api.nvim_set_hl(0, "FzfLuaTitle", { link = "FloatTitle", force = true })
vim.api.nvim_set_hl(0, "FzfLuaPreviewNormal", { link = "FloatPreviewNormal", force = true })
vim.api.nvim_set_hl(0, "FzfLuaPreviewTitle", { link = "FloatPreviewTitle", force = true })
vim.api.nvim_set_hl(0, "FzfLuaPreviewBorder", { link = "FloatPreviewBorder", force = true })

fzf_lua.setup({
	{ "cli" },
	fzf_colors = {
		["fg"] = { "fg", "FzfLuaNormal" },
		["bg"] = { "bg", "FzfLuaNormal" },
		["border"] = { "fg", "FzfLuaBorder" },
		["gutter"] = { "bg", "FzfLuaNormal" },
		["header"] = { "fg", "FzfLuaTitle", "italic" },
		["preview-bg"] = { "bg", "FzfLuaPreviewNormal" },
		["preview-border"] = { "fg", "FzfLuaPreviewBorder" },
	},
	winopts = {
		border = "none",
		preview = {
			title = false,
			scrollbar = false,
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		},
	},
	fzf_opts = {
		["--info"] = "inline-right",
		["--padding"] = "1",
		["--wrap"] = true,
	},
	files = {
		fzf_opts = {
			["--info"] = "inline-right",
		},
	},
	keymap = {
		fzf = {
			["ctrl-u"] = "preview-half-page-up",
			["ctrl-d"] = "preview-half-page-down",
			["ctrl-p"] = "toggle-preview",
		},
	},
	actions = {
		files = {
			["ctrl-g"] = actions.toggle_ignore,
			["ctrl-h"] = actions.toggle_hidden,
		},
	},
})

local function projects(dir)
	if not dir then
		dir = "$dev"
	end
	---@type string|nil
	local parent = vim.fn.fnamemodify(dir, ":h")
	if parent == "." then
		parent = nil
	end

	local prompt_suffix = ""
	if dir ~= "$dev" then
		prompt_suffix = dir:gsub("^$dev/", "") .. " "
	end

	fzf_lua.fzf_exec("fd --type d --base-directory " .. dir .. " --path-separator '' --max-depth 1 --prune", {
		prompt = "Development Projects> " .. prompt_suffix,
		fn_transform = fzf_lua.utils.ansi_codes.blue,
		actions = {
			["default"] = function(selected)
				files.files({ cwd = dir .. "/" .. selected[1] })
			end,
			["btab"] = function()
				projects(parent)
			end,
			["tab"] = function(selected)
				projects(dir .. "/" .. selected[1])
			end,
			["ctrl-l"] = function(selected)
				grep.live_grep({ cwd = dir .. "/" .. selected[1] })
			end,
			["ctrl-d"] = cd(dir),
			["ctrl-e"] = function(selected)
				cd(dir)(selected)
				vim.schedule(function()
					posix_exec(vim.fn.exepath("nvim"))
					quit()
				end)
			end,
		},
	})
end

FzfLua.projects = function()
	return projects()
end
