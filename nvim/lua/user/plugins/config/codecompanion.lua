---@type LazyPluginSpec
return {
  "olimorris/codecompanion.nvim",
  enabled = vim.env.USER == "nhurlock",
  config = function()
    local adapters = require('codecompanion.adapters')
    require('codecompanion').setup({
      adapters = {
        chat = adapters.extend(
          'ollama',
          { schema = { model = { default = 'qwen2.5-coder:14b' } } }
        ),
        inline = adapters.extend(
          'ollama',
          { schema = { model = { default = 'qwen2.5-coder:14b' } } }
        ),
      },
      strategies = {
        chat = {
          adapter = "ollama",
          slash_commands = {
            ["buffer"] = {
              opts = {
                provider = "fzf_lua"
              }
            },
            ["file"] = {
              opts = {
                provider = "fzf_lua"
              }
            },
            ["help"] = {
              opts = {
                provider = "fzf_lua"
              }
            },
            ["symbols"] = {
              opts = {
                provider = "fzf_lua"
              }
            },
          }
        },
        inline = {
          adapter = "ollama"
        }
      }
    })
  end,
}
