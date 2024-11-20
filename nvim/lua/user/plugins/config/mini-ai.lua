---@type LazyPluginSpec
return {
  "echasnovski/mini.ai",
  opts = {
    mappings = {
      -- Main textobject prefixes
      around = 'a',
      inside = 'i',

      -- Next/last variants
      around_next = 'an',
      inside_next = 'in',
      around_last = 'aN',
      inside_last = 'iN',

      -- Move cursor to corresponding edge of `a` textobject
      goto_left = 'g[',
      goto_right = 'g]',
    },
    search_method = 'cover_or_next'
  }
}
