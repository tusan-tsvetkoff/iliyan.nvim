return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
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
    'hrsh7th/cmp-cmdline',
  },
  opts = function()
    return require 'custom.config.cmp'
  end,
  config = function(_, opts)
    require('cmp').setup(opts)
  end,
}
