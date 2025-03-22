-- idea originally taken from: https://github.com/willothy/nvim-config/blob/a4bf083dc046abedb2575824419000e4d39e9184/lua/configs/ui/noice.lua
-- which is similar to the mini backend: https://github.com/folke/noice.nvim/blob/bf67d70bd7265d075191e7812d8eb42b9791f737/lua/noice/view/backend/mini.lua#L10
-- modified to work with timeouts and dismissal

local Util = require('noice.util')
local View = require('noice.view')
local fidget = require('fidget')
local require = require('noice.util.lazy')

---@class NoiceFidgetOptions
---@field timeout integer
---@field reverse? boolean
local defaults = { timeout = 1000 }

---@class FidgetView: NoiceView
---@field active table<number, NoiceMessage>
---@field super NoiceView
---@field timers table<number, uv_timer_t>
---@field _group string
---@field _prev_active table<number, NoiceMessage>
---@diagnostic disable-next-line: undefined-field
local FidgetView = View:extend('FidgetView')

function FidgetView:init(opts)
  FidgetView.super.init(self, opts)
  self.active = {}
  self.timers = {}
  self._group = 'noice'
  self._instance = 'view'
  self._prev_active = {}
  self._view_opts = {
    format = { '{message}' },
  }
end

function FidgetView:update_options()
  self._opts = vim.tbl_deep_extend('force', defaults, self._opts)
end

---@param message NoiceMessage
function FidgetView:can_hide(message)
  if message.opts.keep and message.opts.keep() then
    return false
  end
  return not Util.is_blocking()
end

function FidgetView:autohide(id)
  if not self.timers[id] then
    self.timers[id] = vim.uv.new_timer()
  end
  self.timers[id]:start(self._opts.timeout, 0, function()
    if not self.active[id] then
      return
    end
    if not self:can_hide(self.active[id]) then
      return self:autohide(id)
    end
    self.active[id] = nil
    self.timers[id] = nil
    vim.schedule(function()
      self:update()
    end)
  end)
end

function FidgetView:show()
  for _, message in ipairs(self._messages) do
    -- we already have debug info,
    -- so make sure we dont regen it in the child view
    message._debug = true
    self.active[message.id] = message
    self:autohide(message.id)
  end
  self:clear()
  self:update()
end

function FidgetView:dismiss()
  self:clear()
  self.active = {}
  self:update()
end

---@param message NoiceMessage
function FidgetView:upsert(message)
  fidget.notify(message:content(), message.level or vim.log.levels.INFO, {
    key = message.id,
    group = self._group,
    annote = message.opts.title,
    ttl = self._opts.timeout / 1000,
  })
end

---@param message NoiceMessage
function FidgetView:remove(message)
  fidget.notification.remove(self._group, message.id)
end

function FidgetView:update()
  ---@type NoiceMessage[]
  local active = vim.tbl_values(self.active)
  table.sort(
    active,
    ---@param a NoiceMessage
    ---@param b NoiceMessage
    function(a, b)
      local ret = a.id < b.id
      if self._opts.reverse then
        return not ret
      end
      return ret
    end
  )

  ---@type table<number, NoiceMessage>
  local next_messages = {}
  for _, message in pairs(active) do
    next_messages[message.id] = message
    self:upsert(message)
  end

  for id, message in pairs(self._prev_active) do
    if next_messages[id] == nil then
      self:remove(message)
    end
  end

  self._prev_active = self.active
end

function FidgetView:hide()
  self.active = {}
  self.timers = {}
  self._prev_active = {}
  fidget.notification.clear(self._group)
end

package.loaded['noice.view.backend.fidget'] = FidgetView
