---@type LazyPluginSpec
return {
  'nvim-mini/mini.ai',
  version = false,
  opts = {
    n_lines = 300,
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
    search_method = 'cover_or_next',
  },
}
