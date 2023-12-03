--- Diagnostic settings
local signs = require('custom.plugins.utils.icons') -- only used for the type names
-- Configures it so that dignostic warnings
-- are shown (highlighted) in the line column
-- leaving space for the gitsigns in the sign column
for type, _ in pairs(signs.diagnostics) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = '', linehl = hl, texthl = hl, numhl = hl })
end

vim.api.nvim_set_keymap('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

vim.diagnostic.config({
  underline = false,
  virtual_text = {
    source = "always",
    prefix = function(diagnostic)
      if diagnostic.severity == vim.diagnostic.severity.ERROR then
        return signs.diagnostics.Error .. " "
      elseif diagnostic.severity == vim.diagnostic.severity.WARN then
        return signs.diagnostics.Warn .. " "
      elseif diagnostic.severity == vim.diagnostic.severity.HINT then
        return signs.diagnostics.Hint .. " "
      else
        return signs.diagnostics.Info .. " "
      end
    end,
  },
  severity_sort = true,
  float = {
    source = "always", -- Or "if_many"
  },
})
