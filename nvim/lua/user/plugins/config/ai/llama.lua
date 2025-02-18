-- llama-server \
--     -hf ggml-org/Qwen2.5-Coder-7B-Q8_0-GGUF \
--     --port 8012 -ngl 99 -fa -ub 1024 -b 1024 \
--     --ctx-size 0 --cache-reuse 256

---@type LazyPluginSpec
return {
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
}
