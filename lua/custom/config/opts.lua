local opt = vim.opt
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchparen = 1

vim.g['OmniSharp_server_path'] = 'OmniSharp'
--------------------------------------------------------
opt.hlsearch = false
opt.incsearch = true

opt.showmatch = true
opt.errorbells = false

-- Enable mouse mode
opt.mouse = 'a'
opt.mousemoveevent = true
opt.cursorline = true

opt.cmdheight = 1
opt.inccommand = 'split'

opt.hidden = true

-- Soy
opt.clipboard = 'unnamedplus'

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
opt.ignorecase = true
opt.smartcase = true

-- Always block cursor
opt.guicursor = 'n-v-c-i:block'

opt.nu = true
opt.relativenumber = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.shiftround = true

opt.smartindent = true
opt.smarttab = true

opt.backup = false
opt.swapfile = false

opt.scrolloff = 4
opt.sidescrolloff = 4
opt.isfname:append '@-@'

-- Keep signcolumn on by default
opt.signcolumn = 'yes:1'

-- Decrease update time
opt.updatetime = 50

opt.colorcolumn = '80'

-- Set completeopt to have a better completion experience
opt.completeopt = { 'menuone', 'noselect' }

opt.termguicolors = true
