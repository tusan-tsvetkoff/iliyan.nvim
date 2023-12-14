return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufRead', 'BufNewFile' },
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = {},
      },
      'williamboman/mason-lspconfig.nvim', -- Useful status updates for LSP
      {
        'j-hui/fidget.nvim',
        opts = {},
      }, -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
}
