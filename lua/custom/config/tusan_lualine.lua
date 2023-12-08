local lualine = require 'lualine'
local icons = require 'custom.plugins.utils.icons'

-- stylua: ignore
local colors = {
  bg       = '#202328',
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

---@return string
local function selectionCount()
  local isVisualMode = vim.fn.mode():find '[Vv]'
  if not isVisualMode then
    return ''
  end
  local starts = vim.fn.line 'v'
  local ends = vim.fn.line '.'
  local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
  return '󰉸' .. tostring(lines) .. 'L ' .. tostring(vim.fn.wordcount().visual_chars) .. 'C'
end

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
    theme = {
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
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

local backup = string.upper(vim.fn.mode():sub(1, 1))
-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

-- Set up a timer to update the status line periodically

local mode_icon = {
  n = '󰫻',
  i = '',
  v = '󱂌',
  ['^V'] = '󱂌󱎦',
  V = '󱂌󱎦',
  c = '󰫰',
  no = '󰬹󰫽',
  s = '',
  S = '󱂌󱎦',
  [''] = '󱂌',
  ic = '',
  R = '󰫿',
  Rv = '󱂌󰫿',
  cv = '󰫲',
  ce = '󰫻󰫰',
  r = '󰫿',
  rm = '󱂌󰫿',
  ['r?'] = '󰫰',
  ['!'] = '󰫰',
  t = '󰬁',
}

local mode_color = {
  n = colors.red,
  i = colors.green,
  v = colors.blue,
  [''] = colors.blue,
  V = colors.blue,
  c = colors.magenta,
  no = colors.red,
  s = colors.orange,
  S = colors.orange,
  [''] = colors.orange,
  ic = colors.yellow,
  R = colors.violet,
  Rv = colors.violet,
  cv = colors.red,
  ce = colors.red,
  r = colors.cyan,
  rm = colors.cyan,
  ['r?'] = colors.cyan,
  ['!'] = colors.red,
  t = colors.red,
}

local os_colors = {
  ['unix'] = { fg = '#A349A4', gui = 'bold' },
  ['mac'] = { fg = '#A349A4', gui = 'bold' },
  ['dos'] = { fg = '#00A2FF', gui = 'bold' },
}

ins_left {
  function()
    return '▊'
  end,
  color = { fg = mode_color[vim.fn.mode()] }, -- Sets highlighting of component
  padding = { left = 0, right = 1 },          -- We don't need space before this
}

ins_left {
  function()
    return '' .. ' ' .. mode_icon[vim.fn.mode()]
  end,
  color = function()
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { right = 1 },
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
  color = { fg = colors.blue, gui = 'italic' },
}

ins_left {
  'branch',
  icons_enabled = true,
  icon = icons.git.Branch,
  color = { fg = colors.magenta, gui = 'bold' },
}

ins_left {
  'diff',
  -- Is it me or the symbol for modified us really weird
  colored = true,
  symbols = { added = icons.git.Add, modified = icons.git.Modify, removed = icons.git.Delete },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
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
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
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
  path = 0,
  -- fmt = function(path)
  --   ---@diagnostic disable-next-line: param-type-mismatch
  --   return table.concat({ vim.fs.basename(vim.fs.dirname(path)), vim.fs.basename(path) }, package.config:sub(1, 1))
  -- end,
  symbols = {
    modified = icons.file.ModifiedFile,
    readonly = icons.file.ReadOnlyFile,
    unnamed = icons.file.UnNamedFile,
    newfile = icons.file.NewFile,
  },
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.magenta, gui = 'bold' },
}

-- ins_left {
--   function()
--     return '%='
--   end,
-- }

ins_right {
  -- Lsp server name .
  function()
    local msg = 'No Active Lsp'
    local bufnr = { bufnr = vim.api.nvim_get_current_buf() }
    local clients = vim.lsp.get_clients(bufnr)
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      return client.name
    end
    return msg
  end,
  icon = ' LSP:',
  color = { fg = '#ffffff', gui = 'bold' },
}
ins_right {
  'fileformat',
  icons_enabled = true, -- I think icons are cool and Tusanline has them :')
  symbols = { dos = '', unix = '', mac = '' },
  color = os_colors[vim.bo.fileformat],
}

ins_right { 'location', padding = { right = 0 } }
ins_right {
  function()
    return ' ' .. os.date '%R'
  end,
}

ins_right {
  function()
    return '▊'
  end,
  color = { fg = colors.blue },
  padding = { left = 1 },
}

-- Now don't forget to initialize lualine
lualine.setup(config)
