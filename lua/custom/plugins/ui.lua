return {
  -- better vim.ui
  {
    'stevearc/dressing.nvim',
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.input(...)
      end
    end,
  },
  {
    'simrat39/symbols-outline.nvim',
    opts = {},
    config = function(_, opts)
      require('symbols-outline').setup(opts)
    end,
  },
  {
    'anuvyklack/windows.nvim',
    event = 'WinNew',
    dependencies = {
      { 'anuvyklack/middleclass' },
      { 'anuvyklack/animation.nvim', enabled = false },
    },
    keys = { { '<leader>m', '<cmd>WindowsMaximize<cr>', desc = 'Zoom' } },
    config = function()
      vim.o.winwidth = 5
      vim.o.equalalways = false
      require('windows').setup {
        animation = { enable = false, duration = 150 },
      }
    end,
  },
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons', -- optional dependency
    },
    theme = 'tokyonight',
  },
  {
    'HiPhish/nvim-ts-rainbow2',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
}
