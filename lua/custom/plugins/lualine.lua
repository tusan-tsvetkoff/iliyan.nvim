local fn = vim.fn

local function selectionCount()
  local isVisualMode = fn.mode():find("[Vv]")
  if not isVisualMode then return "" end
  local starts = fn.line("v")
  local ends = fn.line(".")
  local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
  return " " .. tostring(lines) .. "L " .. tostring(fn.wordcount().visual_chars) .. "C"
end

-------------------------------------------------
return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  config = function()
    local icons = require("custom.plugins.utils.icons")
    -- require('gruvbox').setup()
    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'gruvbox',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b =
        {
          {
            'branch',
            icons_enabled = true,
            icon = icons.git.Branch,
          },
          {
            'diff',
            colored = true,
            symbols = { added = icons.git.Add, modified = icons.git.Modify, removed = icons.git.Delete }
          },
        },
        lualine_c =
        {
          {
            'filetype',
            colored = true,
            icon_only = true,
            icon = { align = 'left' }
          },
          {
            "filename",
            file_status = true,
            newfile_status = true,
            path = 0,
            symbols = {
              modified = icons.file.ModifiedFile,
              readonly = icons.file.ReadOnlyFile,
              unnamed = icons.file.UnNamedFile,
              newfile = icons.file.NewFile
            }
          },
        },
        lualine_x =
        {
          {
            'diagnostics',
            sources = { 'nvim_lsp', 'nvim_diagnostic' },
            sections = { 'error', 'warn', 'info', 'hint' },
            icons_enabled = true,
            update_in_insert = true,
            symbols = { error = icons.diagnostics.Error, warn = icons.diagnostics.Warn, info = icons.diagnostics.Info, hint = icons.diagnostics.Hint },
            always_visible = true,
          },
          {
            'fileformat',
            symbols = { dos = '', unix = '', mac = '' },
          }
        },
        lualine_y = {},
        lualine_z = {
          { selectionCount(), padding = { left = 0, right = 1 } },
          'location'
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            file_status = true,
            newfile_status = true,
            path = 1,
            symbols = {
              modified = icons.file.ModifiedFile,
              readonly = icons.file.ReadOnlyFile,
              unnamed = icons.file.UnNamedFile,
              newfile = icons.file.NewFile
            }
          }
        },
        lualine_x = {
          {
            "fileformat",
            symbols = { unix = icons.file.Linux, mac = icons.file.Mac, dos = icons.file.Win }
          }
        },
        lualine_y = { 'progress' },
        lualine_z = {}
      },
      extensions = { 'neo-tree', 'fugitive', 'lazy' },
    })
  end
}
-------------------------------------------------
