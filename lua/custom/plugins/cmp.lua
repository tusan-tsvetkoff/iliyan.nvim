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
    local cmp = require 'cmp'
    cmp.setup(opts)
    local presentAutopairs, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
    if not presentAutopairs then
      return
    end
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })
  end,
}
