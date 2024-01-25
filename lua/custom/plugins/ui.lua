return {
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        vim.o.statusline = ' '
      else
        vim.o.laststatus = 0
      end
    end,
  },
  {
    'tzachar/highlight-undo.nvim',
    keys = { 'u', 'U' },
    opts = {
      duration = 250,
      undo = {
        lhs = 'u',
        map = 'silent undo',
        opts = { desc = '󰕌 Undo' },
      },
      redo = {
        lhs = 'U',
        map = 'silent redo',
        opts = { desc = '󰑎 Redo' },
      },
    },
    config = function(_, opts)
      require('highlight-undo').setup(opts)
    end,
  },
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
  -- { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
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
