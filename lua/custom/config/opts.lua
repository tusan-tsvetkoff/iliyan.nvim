local opt = vim.opt

vim.g['OmniSharp_server_path'] = 'OmniSharp'
vim.g.markdown_recommended_style = 0
vim.scriptencoding = 'utf-8'

--------------------------------------------------------
opt.fileencoding = 'utf-8'
opt.encoding = 'utf-8'

opt.title = true

vim.cmd [[let &t_Cs = "\e[4:3m"]]
vim.cmd [[let &t_Ce = "\e[4:0m"]]

opt.hlsearch = false
opt.incsearch = true

-- Do not show mode
opt.showmode = false

-- Pseudo transparency for floating window
opt.winblend = 10

-- Pseudo transparency for completion menu
opt.pumblend = 10

-- Fix markdown indentation settings

opt.smoothscroll = true

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
opt.synmaxcol = 512
