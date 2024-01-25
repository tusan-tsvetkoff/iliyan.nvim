local Util = require 'custom.util'

---@class custom.util.lualine
local M = {}

-- stylua: ignore
M.rosepine_colors = {
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

M.conditions = {
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
M.config = {
  options = {
    component_separators = '',
    section_separators = '',
    theme = 'tokyonight',
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

local modes = {
  ['n'] = 'NORMAL',
  ['no'] = 'NORMAL (no)',
  ['nov'] = 'NORMAL (nov)',
  ['noV'] = 'NORMAL (noV)',
  ['noCTRL-V'] = 'NORMAL',
  ['niI'] = 'NORMAL i',
  ['niR'] = 'NORMAL r',
  ['niV'] = 'NORMAL v',
  ['nt'] = 'NTERMINAL',
  ['ntT'] = 'NTERMINAL (ntT)',

  ['v'] = 'VISUAL',
  ['vs'] = 'V-CHAR (Ctrl O)',
  ['V'] = 'V-LINE',
  ['Vs'] = 'V-LINE',
  [''] = 'V-BLOCK',

  ['i'] = 'INSERT',
  ['ic'] = 'INSERT (completion)',
  ['ix'] = 'INSERT completion',

  ['t'] = 'TERMINAL',

  ['R'] = 'REPLACE',
  ['Rc'] = 'REPLACE (Rc)',
  ['Rx'] = 'REPLACEa (Rx)',
  ['Rv'] = 'V-REPLACE',
  ['Rvc'] = 'V-REPLACE (Rvc)',
  ['Rvx'] = 'V-REPLACE (Rvx)',

  ['s'] = 'SELECT',
  ['S'] = 'S-LINE',
  [''] = 'S-BLOCK',
  ['c'] = 'COMMAND',
  ['cv'] = 'COMMAND',
  ['ce'] = 'COMMAND',
  ['r'] = 'PROMPT',
  ['rm'] = 'MORE',
  ['r?'] = 'CONFIRM',
  ['x'] = 'CONFIRM',
  ['!'] = 'SHELL',
}
---@param mode string the mode to map
---@param to_lower boolean | Optional whether to return the mode name in lower case
---@return string mode_name the full name of the mode or the mode itself in lower case if to_lower is true
function M.map_mode(mode, to_lower)
  local result = modes[mode]
  if to_lower then
    return result and result:lower() or mode:lower()
  end
  return result and result or mode:upper()
end

---@return table
function M.get_lsp_clients()
  local bufnr = { bufnr = vim.api.nvim_get_current_buf() }
  local clients = vim.lsp.get_clients(bufnr)
  return clients
end

---@return boolean
function M.is_copilot_on()
  local clients = M.get_lsp_clients()
  for _, client in ipairs(clients) do
    if string.match(client.name, 'copilot') then
      return true
    end
  end
  return false
end

-- Inserts a component in lualine_c at left section
---@param component table
function M.ins_left(component)
  table.insert(M.config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
---@param component table
function M.ins_right(component)
  table.insert(M.config.sections.lualine_x, component)
end

---@type table<string, string>
M.gui_types = {
  bold = 'bold',
  italic = 'italic',
}

---@type table<string, string>
M.copilot_icons = {
  [''] = Util.icons.copilot.Normal,
  ['Normal'] = Util.icons.copilot.Normal,
  ['Warning'] = Util.icons.copilot.Warning,
  ['InProgress'] = Util.icons.copilot.Normal,
}

---@type table<string, string>
M.copilot_colors = {
  [''] = M.rosepine_colors.foam,
  ['Normal'] = M.rosepine_colors.foam,
  ['Warning'] = M.rosepine_colors.love,
  ['InProgress'] = M.rosepine_colors.gold,
}

---@type table<string, string>
M.mode_color = {
  n = M.rosepine_colors.love,
  i = M.rosepine_colors.gold,
  v = M.rosepine_colors.iris,
  [''] = M.rosepine_colors.iris,
  V = M.rosepine_colors.iris,
  c = M.rosepine_colors.foam,
  no = M.rosepine_colors.gold,
  s = M.rosepine_colors.gold,
  S = M.rosepine_colors.gold,
  [''] = M.rosepine_colors.gold,
  ic = M.rosepine_colors.gold,
  R = M.rosepine_colors.pine,
  Rv = M.rosepine_colors.pine,
  cv = M.rosepine_colors.love,
  ce = M.rosepine_colors.love,
  r = M.rosepine_colors.iris,
  rm = M.rosepine_colors.iris,
  ['r?'] = M.rosepine_colors.iris,
  ['!'] = M.rosepine_colors.love,
  t = M.rosepine_colors.love,
}

---@type table<string, table>
M.os_colors = {
  ['unix'] = { fg = '#A349A4', gui = M.gui_types.bold },
  ['mac'] = { fg = '#A349A4', gui = M.gui_types.bold },
  ['dos'] = { fg = '#00A2FF', gui = M.gui_types.bold },
}

return M
