---@class custom.util
---@field icons custom.util.icons
---@field lualine custom.util.lualine
local M = {}

setmetatable(M, {
  __index = function(t, k)
    local success, submodule = pcall(require, 'custom.util.' .. k)
    if success then
      t[k] = submodule
      return submodule
    else
      error("Failed to load submodule '" .. k .. "': " .. submodule)
    end
  end,
})

return M
