return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'haringsrob/nvim_context_vt',
  },
  build = ':TSUpdate',
  event = 'VeryLazy',
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'json',
      'c',
      'cpp',
      'go',
      'lua',
      'python',
      'rust',
      'tsx',
      'javascript',
      'typescript',
      'vimdoc',
      'vim',
      'bash',
      'c_sharp',
    },

    -- refactor = {
    --   highlight_definitions = { enable = true },
    --   highlight_current_scope = { enable = false },
    --   smart_rename = {
    --     enable = true,
    --     keymaps = {
    --       smart_rename = '<leader>v',
    --     },
    --   },
    -- },
    -- endwise = { enable = true },
    -- tree_setter = { enable = true },
    -- matchup = { enable = true },
    highlight = {
      enable = true,
      indent = { enable = true },
    },

    -- incremental_selection = {
    --   enable = true,
    --   keymaps = {
    --     init_selection = '<c-space>',
    --     node_incremental = '<c-space>',
    --     scope_incremental = '<c-s>',
    --     node_decremental = '<M-space>',
    --   },
    -- },

    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
}
