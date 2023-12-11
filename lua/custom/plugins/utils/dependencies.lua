local M = {}

M.cmp = {
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
      opts = {
        history = true,
        updateevents = 'TextChanged,TextChangedI',
      },
      config = function(_, opts)
        require('custom.config.others').luasnip(opts)
      end,
    },
  },
  'saadparwaiz1/cmp_luasnip',
  'hrsh7th/cmp-emoji',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-nvim-lsp-signature-help',
}

M.lspconfig = {
  {
    'williamboman/mason.nvim',
    opts = {
      ui = {
        border = 'rounded',
      },
    },
  },
  'williamboman/mason-lspconfig.nvim', -- Useful status updates for LSP
  {
    'j-hui/fidget.nvim',
    opts = {},
  }, -- Additional lua configuration, makes nvim stuff amazing!
  'folke/neodev.nvim',
}

M.telescope = {
  'nvim-lua/plenary.nvim',
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
}

return M
