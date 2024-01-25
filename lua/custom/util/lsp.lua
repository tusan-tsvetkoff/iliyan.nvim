---@class custom.util.lsp
local M = {}
local Util = require 'custom.util'

---@param from string
---@param to string
function M.on_rename(from, to)
  local clients = Util.lualine.get_lsp_clients()
  for _, client in ipairs(clients) do
    if client.supports_method 'workspace/willRenameFiles' then
      ---@diagnostic disable-next-line: invisible
      local resp = client.request_sync('workspace/willRenameFiles', {
        files = {
          {
            oldUri = vim.uri_from_fname(from),
            newUri = vim.uri_from_fname(to),
          },
        },
      }, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
end

return M
