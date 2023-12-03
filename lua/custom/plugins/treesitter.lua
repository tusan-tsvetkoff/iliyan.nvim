return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    "haringsrob/nvim_context_vt",
  },
  build = ':TSUpdate',
  event = 'VeryLazy',
  main = 'nvim-treesitter.configs'
}
