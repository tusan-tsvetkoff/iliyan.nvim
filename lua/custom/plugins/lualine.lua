--- Copilot status (not working for some reason)
local copilot_status = require('copilot_status')

---@return string
local copilot_status_string = function()
  return copilot_status.status_string()
end

---@return boolean
local copilot_status_cnd = function()
  return copilot_status.enabled()
end
-------------------------------------------------
local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
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
    require('lualine').setup({
      options = {
        always_divide_middle = true,
        icons_enabled = true,
        theme = 'gruvbox',
        sections = {
          lualine_a = { 'mode' },
          lualine_b =
          {
            'branch',
            icons_enabled = true,
          },
          {
            'diff',
            colored = true,
            diff_color = { added = "DiffAdd", modified = "DiffChange", removed = "DiffDelete" },
            symbols = { added = icons.git.Add, modified = icons.git.Modify, removed = icons.git.Delete }
          },
          lualine_c =
          {
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
            },
            {
              'diagnostics',
              sources = { 'nvim_lsp', 'nvim_diagnostic' },
              sections = { 'error', 'warn', 'info', 'hint' },
              colored = true,
              icons_enabled = true,
              diagnostics_color = { error = "DiagnosticError", warn = "DiagnosticWarn", info = "DiagnosticInfo", hint = "DiagnosticHint" },
              update_in_insert = true,
              symbols = { error = icons.diagnostics.Error, warn = icons.diagnostics.Warn, info = icons.diagnostics.Info, hint = icons.diagnostics.Hint },
              always_visible = true,
            }
          },
          lualine_x =
          {
            'encoding',
            {
              'filetype',
              colored = true,
              icon_only = false,
              icon = { align = 'left' }
            },
            {
              'fileformat',
              symbols = { dos = '', unix = '', mac = '' },
            }
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
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
          lualine_y = {},
          lualine_z = {}
        },
        extensions = { 'neo-tree', 'fugitive', 'lazy' },
      },
    })
  end
}
-------------------------------------------------
