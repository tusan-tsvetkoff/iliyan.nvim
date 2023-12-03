return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    {
      "s1n7ax/nvim-window-picker",
      -- branch = 'v2.*',
      config = function()
        require('window-picker').setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
              buftype = { 'terminal', 'quickfix' }
            },
          },
        })
      end
    },
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  init = function()
    local keymap = vim.keymap.set
    keymap("n", "-", ":Neotree toggle<CR>", { desc = "Toggle NeoTree", silent = true })
  end,
  config = {
    close_if_last_window = true,
    enable_git_status = false,
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = {
        enabled = true,
      },
    },
    window = {
      position = "current",
      mappings = {
        ["-"] = "close_window",
        ["/"] = "noop",
      }
    }
  }
}
