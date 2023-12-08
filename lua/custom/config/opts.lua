local o = vim.o
local opt = vim.opt

--------------------------------------------------------
o.hlsearch = false
o.incsearch = true

-- Enable mouse mode
o.mouse = 'a'
o.mousemoveevent = true
opt.cursorline = true

-- Soy
o.clipboard = 'unnamedplus'

-- Enable break indent
o.breakindent = true

-- Save undo history
o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
o.ignorecase = true
o.smartcase = true

-- Always block cursor
opt.guicursor = 'n-v-c-i:block'

o.nu = true
o.relativenumber = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.shiftround = true

opt.smartindent = true

opt.backup = false
opt.swapfile = false

opt.scrolloff = 4
opt.sidescrolloff = 4
opt.isfname:append '@-@'

-- Keep signcolumn on by default
opt.signcolumn = 'yes:1'

-- Decrease update time
o.updatetime = 50

opt.colorcolumn = '80'

-- Set completeopt to have a better completion experience
o.completeopt = 'menuone,noselect'

opt.termguicolors = true
