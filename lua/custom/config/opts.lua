local autocmd = vim.api.nvim_create_autocmd
local opt_local = vim.opt_local
local o = vim.o
local opt = vim.opt
local wo = vim.wo

--------------------------------------------------------
o.hlsearch = false
o.incsearch = true

-- Enable mouse mode
o.mouse = 'a'

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
opt.guicursor = "n-v-c-i:block"

o.nu = true
o.relativenumber = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartindent = true

opt.backup = false
opt.swapfile = false

opt.scrolloff = 8
opt.sidescrolloff = 8
opt.isfname:append("@-@")

-- Keep signcolumn on by default
-- wo.signcolumn = 'yes'
opt.signcolumn = 'yes:1'

-- Decrease update time
o.updatetime = 50

opt.colorcolumn = "80"

-- Set completeopt to have a better completion experience
o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
o.termguicolors = true

------------------------Autocommands--------------------------
-- Stop auto newline continuation of comments
autocmd("FileType", {
  callback = function() opt_local.formatoptions:remove("o") end,
})

-- Notify when coming back to a file that does not exist anymore
autocmd("FocusGained", {
  callback = function()
    ---@diagnostic disable-next-line: param-type-mismatch
    local fileExists = vim.loop.fs_stat(vim.fn.expand("%")) ~= nil
    local specialBuffer = vim.bo.buftype ~= ""
    if not fileExists and not specialBuffer then
      vim.notify("File does not exist anymore.", vim.log.levels.WARN, { timeout = 20000 })
    end
  end,
})
