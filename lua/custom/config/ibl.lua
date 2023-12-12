local exclude_ft = { 'help', 'git', 'markdown', 'snippets', 'text', 'gitconfig', 'alpha', 'dashboard' }

require('ibl').setup {
  indent = {
    char = '▏', -- or this '' or this '' or this '▏'
    tab_char = '▏',
  },
  scope = { enabled = false },
  exclude = {
    filetypes = exclude_ft,
    buftypes = {
      'terminal',
      'neotree',
      'Trouble',
      'trouble',
      'notify',
      'lazy',
      'mason',
    },
  },
}

local gid = vim.api.nvim_create_augroup('indent_blankline', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  group = gid,
  command = 'IBLDisable',
})

vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  group = gid,
  callback = function()
    if not vim.tbl_contains(exclude_ft, vim.bo.filetype) then
      vim.cmd [[IBLEnable]]
    end
  end,
})
