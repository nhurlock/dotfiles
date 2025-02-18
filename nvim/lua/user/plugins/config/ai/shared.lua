---@type LazyPluginSpec
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  build = "make",
  opts = function()
    local opts = {
      provider = vim.g.ai_provider,
      file_selector = {
        provider = "fzf",
      },
      behaviour = {
        auto_suggestions = true,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
        enable_token_counting = false
      }
    }

    if opts.provider == "copilot" then
      opts.behaviour.auto_suggestions = false -- disable with copilot, copilot.lua takes care of it
    else
      opts.vendors = {
        llama = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://localhost:8012/v1",
          model = "ggml-org/Qwen2.5-Coder-7B-Q8_0-GGUF",
        }
      }
    end
    return opts
  end
}
