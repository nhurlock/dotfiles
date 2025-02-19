-- llama-server \
--     -hf ggml-org/Qwen2.5-Coder-7B-Q8_0-GGUF \
--     --port 8012 -ngl 99 -fa -ub 1024 -b 1024 \
--     --ctx-size 0 --cache-reuse 256

---@type LazyPluginSpec[]
return {
  {
    "ggml-org/llama.vim",
    enabled = vim.g.ai_provider == "llama",
    init = function()
      vim.g.llama_config = {
        show_info = 0
      }
    end,
    config = function()
      vim.api.nvim_set_hl(0, "llama_hl_hint", { link = "Comment", force = true })
      vim.api.nvim_set_hl(0, "llama_hl_info", { link = "Comment", force = true })
    end
  },
  -- disabling until more testing can be done
  -- seems worse on initial impression
  -- {
  --   'milanglacier/minuet-ai.nvim',
  --   enabled = vim.g.ai_provider == "llama",
  --   opts = {
  --     provider = "openai_fim_compatible",
  --     n_completions = 2,
  --     context_window = 2000,
  --     provider_options = {
  --       openai_fim_compatible = {
  --         api_key = "TERM",
  --         name = "llama",
  --         end_point = "http://localhost:8012/v1/completions",
  --         model = "NA",
  --         optional = {
  --           max_tokens = 256,
  --           top_p = 0.9
  --         },
  --         template = {
  --           suffix = false,
  --           prompt = function(context_before_cursor, context_after_cursor)
  --             return "<|fim_prefix|>"
  --                 .. context_before_cursor
  --                 .. "<|fim_suffix|>"
  --                 .. context_after_cursor
  --                 .. "<|fim_middle|>"
  --           end
  --         }
  --       }
  --     }
  --   }
  -- }
}
