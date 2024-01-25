pcall(require('telescope').load_extension, 'fzf')
local telescope_builtin = require 'telescope.builtin'
local telescope = require('telescope').setup

telescope {
  pickers = {
    find_files = {
      theme = 'dropdown',
    },
    live_grep = {
      theme = 'dropdown',
    },
  },
}

local function find_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  if current_file == '' then
    current_dir = cwd
  else
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  ---@diagnostic disable-next-line: param-type-mismatch
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    telescope_builtin.live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

vim.keymap.set('n', '<leader>?', telescope_builtin.oldfiles, {
  desc = '[?] Find recently opened files',
})
vim.keymap.set('n', '<leader><space>', telescope_builtin.buffers, {
  desc = '[ ] Find existing buffers',
})
vim.keymap.set('n', '<leader>/', function()
  telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, {
  desc = '[/] Fuzzily search in current buffer',
})

vim.keymap.set('n', '<leader>gf', telescope_builtin.git_files, {
  desc = 'Search [G]it [F]iles',
})
vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, {
  desc = '[S]earch [F]iles',
})
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, {
  desc = '[S]earch [H]elp',
})
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, {
  desc = '[S]earch current [W]ord',
})
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, {
  desc = '[S]earch by [G]rep',
})
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', {
  desc = '[S]earch by [G]rep on Git Root',
})
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, {
  desc = '[S]earch [D]iagnostics',
})
