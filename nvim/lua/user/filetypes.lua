vim.filetype.add({
  pattern = {
    ['.*/tasks/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/playbooks/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/.github/workflows/.*%.ya?ml'] = 'yaml.git_actions',
    ['.*%.ya?ml'] = {
      priority = math.huge,
      function(_, bufnr)
        local start_pos = 0
        local line = vim.api.nvim_buf_get_lines(bufnr, start_pos, start_pos + 1, false)
        while line[1] and (line[1] == '---' or line[1] == '') do
          start_pos = start_pos + 1
          line = vim.api.nvim_buf_get_lines(bufnr, start_pos, start_pos + 1, false)
        end
        if line[1] and string.match(line[1], [[^AWSTemplateFormatVersion]]) then
          return 'yaml.cloudformation'
        end
      end,
    },
    ['.*%.json'] = {
      priority = math.huge,
      function(_, bufnr)
        local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
        local line2 = vim.api.nvim_buf_get_lines(bufnr, 1, 2, false)
        if
          (line[1] and string.match(line[1], [[["']AWSTemplateFormatVersion]]))
          or (line2[1] and string.match(line2[1], [[["']AWSTemplateFormatVersion]]))
        then
          return 'json.cloudformation'
        end
      end,
    },
  },
})
