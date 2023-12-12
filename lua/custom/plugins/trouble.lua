return {
  'folke/lsp-colors.nvim',
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      position = 'right',
      icons = true,
      use_diagnostic_signs = true,
    },
  },
}
