---@class custom.util.icons
local M = {}

---@type table<string, string>
M.diagnostics = {
  Error = '',
  Warn = '󱟪',
  Info = '󰽁',
  Hint = '',
}

---@type table<string, string>
M.git = {
  Branch = '',
  Modify = '',
  Add = '',
  Delete = '',
  Untracked = '',
  Ignored = '',
  Unstaged = '󱋭',
  Staged = '',
  Conflict = '',
}

---@type table<string, string>
M.file = {
  ModifiedFile = '',
  ReadOnlyFile = '',
  UnNamedFile = '󱀶',
  NewFile = '',
}

---@type table<string, string>
M.cmp_kinds = {
  Text = '  ',
  Method = '  ',
  Function = '  ',
  Constructor = '  ',
  Field = '  ',
  Variable = '  ',
  Class = '  ',
  Interface = '  ',
  Module = '  ',
  Property = '  ',
  Unit = '  ',
  Value = '  ',
  Enum = '  ',
  Keyword = '  ',
  Snippet = '  ',
  Color = '  ',
  File = '  ',
  Reference = '  ',
  Folder = '  ',
  EnumMember = '  ',
  Constant = '  ',
  Struct = '  ',
  Event = '  ',
  Operator = '  ',
  TypeParameter = '  ',
  CmpItemKindCopilot = '  ',
}

---@type table<string, string>
M.copilot = {
  Normal = '',
  Error = '',
  Warning = '',
}

return M
