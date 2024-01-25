local separators = { left = '', right = '' }
local other_separators = { left = '', right = '' }
local dash_separators = { left = '', right = '' }
local lualine = require 'lualine'
local dev_icons = require 'nvim-web-devicons'
local Util = require 'custom.util'
local wave_colors = require('kanagawa.colors').setup { theme = 'wave' }

--- Could remove this entirely
Util.lualine.ins_left {
  function()
    return '▊'
  end,
  color = function()
    return { bg = Util.lualine.mode_color[vim.fn.mode()], fg = Util.lualine.mode_color[vim.fn.mode()] }
  end, -- Sets highlighting of component
  padding = { left = 0, right = 0 }, -- We don't need space before this
}

Util.lualine.ins_left {
  color = function()
    return { bg = Util.lualine.mode_color[vim.fn.mode()], fg = Util.lualine.rosepine_colors.bg, gui = Util.lualine.gui_types.bold }
  end,
  function()
    return '' .. ' ' .. Util.lualine.map_mode(vim.fn.mode())
  end,
  padding = { right = 1 },
  separator = { left = '', right = separators.right },
}

Util.lualine.ins_left {
  'branch',
  icons_enabled = true,
  icon = Util.icons.git.Branch,
  color = { fg = Util.lualine.rosepine_colors.text, bg = wave_colors.palette.dragonBlack4, gui = Util.lualine.gui_types.bold },
  separator = { left = other_separators.left, right = dash_separators.left },
  padding = { left = 2, right = 1 },
}

Util.lualine.ins_left {
  'diff',
  colored = true,
  symbols = { added = Util.icons.git.Add, modified = Util.icons.git.Modify, removed = Util.icons.git.Delete },
  diff_color = {
    added = { fg = Util.lualine.rosepine_colors.gold },
    modified = { fg = Util.lualine.rosepine_colors.foam },
    removed = { fg = Util.lualine.rosepine_colors.love },
  },
  cond = Util.lualine.conditions.hide_in_width,
  color = { bg = wave_colors.palette.dragonBlack4 },
  separator = { left = '', right = dash_separators.left },
  padding = { left = 1, right = 0 },
}

Util.lualine.ins_left {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = {
    error = Util.icons.diagnostics.Error .. ' ',
    warn = Util.icons.diagnostics.Warn .. ' ',
    info = Util.icons.diagnostics.Info .. ' ',
    hint = Util.icons.diagnostics.Hint .. ' ',
  },
  diagnostics_color = {
    color_error = { fg = Util.lualine.rosepine_colors.love },
    color_warn = { fg = Util.lualine.rosepine_colors.gold },
    color_info = { fg = Util.lualine.rosepine_colors.rose },
  },
}

Util.lualine.ins_left {
  'filetype',
  colored = true,
  icon_only = true,
  padding = { left = 1, right = 0 },
}

Util.lualine.ins_left {
  file_status = true,
  newfile_status = true,
  path = 1,
  symbols = {
    modified = Util.icons.file.ModifiedFile,
    readonly = Util.icons.file.ReadOnlyFile,
    unnamed = Util.icons.file.UnNamedFile,
    newfile = Util.icons.file.NewFile,
  },
  'filename',
  cond = Util.lualine.conditions.buffer_not_empty,
  color = { fg = wave_colors.theme.syn.variable, gui = Util.lualine.gui_types.bold },
}

Util.lualine.ins_left {
  function()
    return '%='
  end,
}

Util.lualine.ins_left {
  function()
    local isVisualMode = vim.fn.mode():find '[Vv]'
    if not isVisualMode then
      return ''
    end
    local starts = vim.fn.line 'v'
    local ends = vim.fn.line '.'
    local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
    return '' .. tostring(lines) .. 'L' .. '\u{A718}' .. tostring(vim.fn.wordcount().visual_chars) .. 'C'
  end,
  padding = { right = 1 },
  color = { fg = Util.lualine.rosepine_colors.iris, gui = Util.lualine.gui_types.italic },
}

Util.lualine.ins_right {
  -- Lsp server name .
  function()
    local msg = '💀' -- Means no lsp client attached
    local client_table = {}
    local clients = Util.lualine.get_lsp_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      if client.name ~= 'copilot' then
        table.insert(client_table, client.name)
      end
    end
    return '⟨ ' .. table.concat(client_table, ', ') .. ' ⟩'
  end,
  icon = '',
  -- Color based on the attached lsp, taken from web-devicons.
  color = function()
    local defaults = { fg = Util.lualine.rosepine_colors.white, gui = Util.lualine.gui_types.bold }
    local curr_filetype = vim.bo.filetype
    local clients = Util.lualine.get_lsp_clients()
    if next(clients) == nil then
      return defaults
    end
    for _, client in ipairs(clients) do
      if client.name == 'omnisharp' then -- Since omnisharp is a special case
        local _, color = dev_icons.get_icon_color_by_filetype(curr_filetype, { default = true })
        return { fg = color, gui = Util.lualine.gui_types.bold }
      end
      if string.match(client.name, curr_filetype) then
        local _, color = dev_icons.get_icon_color_by_filetype(curr_filetype, { default = true })
        return { fg = color, gui = Util.lualine.gui_types.bold }
      end
    end
    return defaults
  end,
}
Util.lualine.ins_right {
  function()
    local status = require('copilot.api').status.data
    return Util.lualine.copilot_icons[status.status] .. (status.message or '')
  end,
  padding = { left = 0, right = 1 },
  color = function()
    if not Util.lualine.is_copilot_on() then
      return
    end
    local status = require('copilot.api').status.data
    return { fg = Util.lualine.copilot_colors[status.status] or Util.lualine.copilot_colors[''] }
  end,
  cond = Util.lualine.is_copilot_on,
}

Util.lualine.ins_right {
  'fileformat',
  icons_enabled = true, -- I think icons are cool and Tusanline has them :')
  symbols = { dos = '', unix = '', mac = '' },
  color = Util.lualine.os_colors[vim.bo.fileformat],
}

Util.lualine.ins_right { 'location', padding = { right = 0 }, color = { fg = Util.lualine.rosepine_colors.subtle } }
Util.lualine.ins_right {
  function()
    return ' ' .. os.date '%R'
  end,
  color = { fg = Util.lualine.rosepine_colors.subtle },
}

Util.lualine.ins_right {
  function()
    return '▊'
  end,
  color = function()
    return { fg = Util.lualine.mode_color[vim.fn.mode()] }
  end, -- Sets highlighting of component
  padding = { left = 1 },
}

-- Now don't forget to initialize lualine
lualine.setup(Util.lualine.config)
