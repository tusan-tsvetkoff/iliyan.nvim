local autocmd = vim.api.nvim_create_autocmd
local opt_local = vim.opt_local
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

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartindent = true

opt.backup = false
opt.swapfile = false

opt.scrolloff = 8
opt.sidescrolloff = 8
opt.isfname:append '@-@'

-- Keep signcolumn on by default
-- wo.signcolumn = 'yes'
opt.signcolumn = 'yes:1'

-- Decrease update time
o.updatetime = 50

opt.colorcolumn = '80'

-- Set completeopt to have a better completion experience
o.completeopt = 'menuone,noselect'

opt.termguicolors = true

------------------------Autocommands--------------------------
-- Stop auto newline continuation of comments
autocmd('FileType', {
  callback = function()
    opt_local.formatoptions:remove 'o'
  end,
})

-- Notify when coming back to a file that does not exist anymore
autocmd('FocusGained', {
  callback = function()
    ---@diagnostic disable-next-line: param-type-mismatch
    local fileExists = vim.loop.fs_stat(vim.fn.expand '%') ~= nil
    local specialBuffer = vim.bo.buftype ~= ''
    if not fileExists and not specialBuffer then
      vim.notify('File does not exist anymore.', vim.log.levels.WARN, { timeout = 20000 })
    end
  end,
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, 'auto-cursorline')
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, 'auto-cursorline')
    end
  end,
})
vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, 'auto-cursorline', cl)
      vim.wo.cursorline = false
    end
  end,
})

-- create directories when needed, when saving a file
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('better_backup', { clear = true }),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    local backup = vim.fn.fnamemodify(file, ':p:~:h')
    backup = backup:gsub('[/\\]', '%%')
    vim.go.backupext = backup
  end,
})
