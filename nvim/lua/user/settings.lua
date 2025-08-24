-- neovide-specific settings
if vim.g.neovide then
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_animation_length = 0.03
  vim.g.neovide_cursor_trail_size = 0.1
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
  vim.g.neovide_scale_factor = 1.0
end

-- cursor config (overwrites default term and cmd cursor - to 'beam')
vim.opt.guicursor = 'n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20,t:ver25-TermCursor'

-- disable continuation of comment when // is not the start of a line
vim.opt.formatoptions:append('o/')

-- break on words
vim.opt.linebreak = true

-- logical breaking newlining
vim.opt.breakindent = true
vim.opt.breakindentopt = 'shift:1,min:0'

-- netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- more sane menu, fuzzy
vim.opt.completeopt = 'menuone,noselect,popup,fuzzy'

-- number formats
vim.opt.nrformats:append('blank')

-- full color support
vim.opt.termguicolors = true

-- line settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- case-insensitive
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- smooth scroll
vim.opt.smoothscroll = true

-- remove escape timeout
vim.opt.ttimeoutlen = 0

-- tabs/indent
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

-- leave 8 lines buffer while scrolling
vim.opt.scrolloff = 8

-- 1 column sign column
vim.opt.signcolumn = 'yes:1'

-- remove 'search hit top/bottom' messages
vim.opt.shortmess:append('s')

-- keep only a single statusline for current window
vim.opt.laststatus = 3
vim.opt.showmode = false

-- save undo history
vim.opt.undofile = true

-- decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- more substitution preview
vim.opt.inccommand = 'split'

-- command line
vim.opt.cmdheight = 0
vim.opt.showcmdloc = 'statusline'

-- remove fillchars for vertical
vim.opt.fillchars = {
  fold = ' ',
  vert = ' ',
}

-- md indent fix
vim.g.markdown_recommended_style = 0

-- increase register sizes
vim.opt.viminfo = "'100,<1000,s1000,h"

if vim.fn.has('wsl') == 1 then
  -- wsl copy/paste support
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
