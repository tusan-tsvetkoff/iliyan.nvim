vim.o.hlsearch = false
vim.o.incsearch = true

-- Enable mouse mode
vim.o.mouse = 'a'

vim.opt.cursorline = true

-- Soy
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Prime thing
vim.opt.guicursor = "n-v-c-i:block"

vim.o.nu = true
vim.o.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.backup = false
vim.opt.swapfile = false

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 50

vim.opt.colorcolumn = "80"

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
