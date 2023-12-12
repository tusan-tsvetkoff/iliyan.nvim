local lualine = require 'lualine'
local icons = require 'custom.plugins.utils.icons'
local dev_icons = require 'nvim-web-devicons'

local tn_colors = require 'tokyonight.colors'

-- stylua: ignore
local colors = {
  iris     = '#c4a7e7',
  pine     = '#31748f',
  foam     = '#9ccfd8',
  rose     = '#ebbcba',
  gold     = '#f6c177',
  love     = '#eb6f92',
  subtle   = '#908caa',
  text     = '#e0def4',
  white    = '#ffffff',
  bg       = '#26233a',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand '%:t') ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand '%:p:h'
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}
-- Config
local config = {
  options = {
    component_separators = '',
    section_separators = '',
    theme = 'tokyonight',
    -- theme = {
    --   normal = { c = { fg = colors.fg, bg = colors.bg } },
    --   inactive = { c = { fg = colors.fg, bg = colors.bg } },
    -- },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

local function get_lsp_clients()
  local bufnr = { bufnr = vim.api.nvim_get_current_buf() }
  local clients = vim.lsp.get_clients(bufnr)
  return clients
end

---@return boolean
local function is_copilot_on()
  local clients = get_lsp_clients()
  for _, client in ipairs(clients) do
    if string.match(client.name, 'copilot') then
      return true
    end
  end
  return false
end

---@diagnostic disable-next-line: unused-local
local backup = string.upper(vim.fn.mode():sub(1, 1))
-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

local gui_types = {
  bold = 'bold',
  italic = 'italic',
}

local copilot_icons = {
  [''] = icons.copilot.Normal,
  ['Normal'] = icons.copilot.Normal,
  ['Warning'] = icons.copilot.Warning,
  ['InProgress'] = icons.copilot.Normal,
}

local copilot_colors = {
  [''] = colors.foam,
  ['Normal'] = colors.foam,
  ['Warning'] = colors.love,
  ['InProgress'] = colors.gold,
}

local mode_color = {
  n = colors.love,
  i = colors.gold,
  v = colors.iris,
  [''] = colors.iris,
  V = colors.iris,
  c = colors.foam,
  no = colors.gold,
  s = colors.gold,
  S = colors.gold,
  [''] = colors.gold,
  ic = colors.gold,
  R = colors.pine,
  Rv = colors.pine,
  cv = colors.love,
  ce = colors.love,
  r = colors.iris,
  rm = colors.iris,
  ['r?'] = colors.iris,
  ['!'] = colors.love,
  t = colors.love,
}

local os_colors = {
  ['unix'] = { fg = '#A349A4', gui = gui_types.bold },
  ['mac'] = { fg = '#A349A4', gui = gui_types.bold },
  ['dos'] = { fg = '#00A2FF', gui = gui_types.bold },
}

--- Could remove this entirely
ins_left {
  function()
    return '▊'
  end,
  color = function()
    return { bg = mode_color[vim.fn.mode()], fg = mode_color[vim.fn.mode()] }
  end, -- Sets highlighting of component
  padding = { left = 0, right = 0 }, -- We don't need space before this
}

ins_left {
  color = function()
    return { bg = mode_color[vim.fn.mode()], fg = colors.bg, gui = gui_types.bold }
  end,
  function()
    return '' .. ' ' .. string.upper(vim.fn.mode())
  end,
  padding = { right = 1 },
  separator = { left = '', right = '' },
}

ins_left {
  'branch',
  icons_enabled = true,
  icon = icons.git.Branch,
  color = { fg = colors.text, gui = gui_types.bold },
}

ins_left {
  'diff',
  -- Is it me or the symbol for modified us really weird
  colored = true,
  symbols = { added = icons.git.Add, modified = icons.git.Modify, removed = icons.git.Delete },
  diff_color = {
    added = { fg = colors.gold },
    modified = { fg = colors.foam },
    removed = { fg = colors.love },
  },
  cond = conditions.hide_in_width,
}

ins_left {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = {
    error = icons.diagnostics.Error .. ' ',
    warn = icons.diagnostics.Warn .. ' ',
    info = icons.diagnostics.Info .. ' ',
    hint = icons.diagnostics.Hint .. ' ',
  },
  diagnostics_color = {
    color_error = { fg = colors.love },
    color_warn = { fg = colors.gold },
    color_info = { fg = colors.rose },
  },
}

ins_left {
  'filetype',
  colored = true,
  icon_only = true,
  padding = { left = 1, right = 0 },
}

ins_left {
  file_status = true,
  newfile_status = true,
  path = 1,
  symbols = {
    modified = icons.file.ModifiedFile,
    readonly = icons.file.ReadOnlyFile,
    unnamed = icons.file.UnNamedFile,
    newfile = icons.file.NewFile,
  },
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.text, gui = gui_types.bold },
}

ins_left {
  function()
    return '%='
  end,
}

ins_left {
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
  color = { fg = colors.iris, gui = gui_types.italic },
}

ins_right {
  -- Lsp server name .
  function()
    local msg = '󰱶 nope_lsp' -- Means no lsp client attached
    local client_table = {}
    local clients = get_lsp_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      if client.name ~= 'copilot' then
        table.insert(client_table, client.name)
      end
    end
    return '[' .. table.concat(client_table, ', ') .. ']'
  end,
  icon = '',
  -- Color based on the attached lsp, taken from web-devicons.
  color = function()
    local defaults = { fg = colors.white, gui = gui_types.bold }
    local curr_filetype = vim.bo.filetype
    local clients = get_lsp_clients()
    if next(clients) == nil then
      return defaults
    end
    for _, client in ipairs(clients) do
      if client.name == 'omnisharp' then -- Since omnisharp is a special case
        local _, color = dev_icons.get_icon_color_by_filetype(curr_filetype, { default = true })
        return { fg = color, gui = gui_types.bold }
      end
      if string.match(client.name, curr_filetype) then
        local _, color = dev_icons.get_icon_color_by_filetype(curr_filetype, { default = true })
        return { fg = color, gui = gui_types.bold }
      end
    end
    return defaults
  end,
}

ins_right {
  function()
    local status = require('copilot.api').status.data
    return copilot_icons[status.status] .. (status.message or '')
  end,
  padding = { left = 0, right = 1 },
  color = function()
    if not is_copilot_on() then
      return
    end
    local status = require('copilot.api').status.data
    return { fg = copilot_colors[status.status] or copilot_colors[''] }
  end,
  cond = is_copilot_on,
}

ins_right {
  'fileformat',
  icons_enabled = true, -- I think icons are cool and Tusanline has them :')
  symbols = { dos = '', unix = '', mac = '' },
  color = os_colors[vim.bo.fileformat],
}

ins_right { 'location', padding = { right = 0 }, color = { fg = colors.subtle } }
ins_right {
  function()
    return ' ' .. os.date '%R'
  end,
  color = { fg = colors.subtle },
}

ins_right {
  function()
    return '▊'
  end,
  color = function()
    return { fg = mode_color[vim.fn.mode()] }
  end, -- Sets highlighting of component
  padding = { left = 1 },
}

-- Now don't forget to initialize lualine
lualine.setup(config)
