--- Diagnostic settings
local signs = require 'custom.plugins.utils.icons'

for type, sign in pairs(signs.diagnostics) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = sign, texthl = hl, numhl = '' })
end

vim.api.nvim_set_keymap('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

vim.diagnostic.config {
  update_in_insert = false,
  underline = true,
  -- virtual_text = {
  --   source = 'always',
  -- },
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    prefix = function(diagnostic)
      if diagnostic.severity == vim.diagnostic.severity.ERROR then
        return signs.diagnostics.Error .. ' '
      elseif diagnostic.severity == vim.diagnostic.severity.WARN then
        return signs.diagnostics.Warn .. ' '
      elseif diagnostic.severity == vim.diagnostic.severity.HINT then
        return signs.diagnostics.Hint .. ' '
      else
        return signs.diagnostics.Info .. ' '
      end
    end,
  },
  inlay_hints = true,
  signs = true,
  severity_sort = true,
  float = {
    source = 'if_many', -- Or "if_many"
    border = 'rounded',
  },
}
