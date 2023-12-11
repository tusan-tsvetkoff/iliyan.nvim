require 'custom.config.ibl'
require 'custom.config.opts'
require 'custom.config.utils'
require 'custom.config.keybindings'
require 'custom.config.diagnostics'
require 'custom.config.autocommands'
require 'custom.config.tusan_lualine'
require 'custom.config.telescope'

local vim_path = vim.fn.stdpath 'config'
local vimopts = 'options.vim'
local path = string.format('%s/%s', vim_path, vimopts)
local source_cmd = 'source ' .. path
vim.cmd(source_cmd)
