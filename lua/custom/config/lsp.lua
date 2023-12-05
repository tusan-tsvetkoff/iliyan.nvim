local api = vim.api
local lsp = vim.lsp
local diagnostic = vim.diagnostic

local custom_attach = function(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    api.nvim_create_autocmd('CursorHold', {
      buffer = bufnr,
      callback = function()
        local float_opts = {
          focusable = false,
          close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
          border = 'rounded',
          source = 'always', -- show source in diagnostic popup window
          prefix = ' ',
        }

        if not vim.b.diagnostics_pos then
          vim.b.diagnostics_pos = { nil, nil }
        end

        local cursor_pos = api.nvim_win_get_cursor(0)
        if (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2]) and #diagnostic.get() > 0 then
          diagnostic.open_float(nil, float_opts)
        end

        vim.b.diagnostics_pos = cursor_pos
      end,
    })
    vim.cmd [[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
    ]]

    local gid = api.nvim_create_augroup('lsp_document_highlight', { clear = true })
    api.nvim_create_autocmd('CursorHold', {
      group = gid,
      buffer = bufnr,
      callback = function()
        lsp.buf.document_highlight()
      end,
    })

    api.nvim_create_autocmd('CursorMoved', {
      group = gid,
      buffer = bufnr,
      callback = function()
        lsp.buf.clear_references()
      end,
    })
  end

  if vim.g.logging_level == 'debug' then
    local msg = string.format('Language server %s started!', client.name)
    vim.notify(msg, vim.log.levels.DEBUG, { title = 'Nvim-config' })
  end

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
  })
end
