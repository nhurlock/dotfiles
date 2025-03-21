---@type LazyPluginSpec
return {
  "3rd/image.nvim",
  dependencies = { "vhyrro/luarocks.nvim" },
  event = "VeryLazy",
  cond = not vim.g.neovide and not vim.env.DIFFVIEW, -- neovide does not have image support atm
  ---@type Options
  opts = {
    backend = "kitty",
    kitty_method = "normal",
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown" }
      }
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true,                                      -- toggles images when windows are overlapped
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    editor_only_render_when_focused = false,                                  -- auto show/hide images when the editor gains/looses focus
    tmux_show_only_in_active_window = false,                                  -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
  }
}
