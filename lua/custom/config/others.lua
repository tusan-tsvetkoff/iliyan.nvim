local M = {}

M.custom_on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    if client.supports_method 'textDocument/inlayHint' then
      require('custom.config.others').toggle_inlay_hints(bufnr, true)
    end

    vim.keymap.set('n', keys, func, {
      buffer = bufnr,
      desc = desc,
    })

    local api = vim.api
    local diagnostic = vim.diagnostic
    local lsp = vim.lsp

    local _border = 'rounded'

    if client.server_capabilities.documentHighlightProvider then
      api.nvim_create_autocmd('CursorHold', {
        buffer = bufnr,
        callback = function()
          local float_opts = {
            focusable = false,
            close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
            border = _border,
            style = 'minimal',
            source = 'always', -- show source in oiagnostic popup window
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

      vim.cmd [[
        hi! link FloatBorder Normal
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
      border = _border,
      style = 'minimal',
    })

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = _border,
      style = 'minimal',
    })

    require('lspconfig.ui.windows').default_options = {
      border = _border,
      style = 'minimal',
    }
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, {
    desc = 'Format current buffer with LSP',
  })
end

M.toggle_inlay_hints = function(buf, value)
  local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
  if type(ih) == 'function' then
    ih(buf, value)
  elseif type(ih) == 'table' and ih.enable then
    if value == nil then
      value = not ih.is_enabled(buf)
    end
    ih.enable(buf, value)
  end
end

M.luasnip = function(opts)
  require('luasnip').config.set_config(opts)

  -- vscode format
  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load { paths = vim.g.vscode_snippets_path or '' }

  -- snipmate format
  require('luasnip.loaders.from_snipmate').load()
  require('luasnip.loaders.from_snipmate').lazy_load { paths = vim.g.snipmate_snippets_path or '' }

  -- lua format
  require('luasnip.loaders.from_lua').load()
  require('luasnip.loaders.from_lua').lazy_load { paths = vim.g.lua_snippets_path or '' }

  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      if require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()] and not require('luasnip').session.jump_active then
        require('luasnip').unlink_current()
      end
    end,
  })
end

M.calculate_max_dimensions = function(contents)
  local max_width = 0
  local max_height = 0

  for _, line in ipairs(contents) do
    local line_length = #line
    if line_length > max_width then
      max_width = line_length
    end
    max_height = max_height + 1
  end

  local additional_padding = 2
  max_width = max_width + additional_padding
  max_height = max_height + additional_padding

  return max_width, max_height
end

local function is_activewin()
  return vim.api.nvim_get_current_win() == vim.g.statusline_winid
end

M.modes = {
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

M.lualine_mode = function()
  if not is_activewin() then
    return ''
  end
  local m = vim.api.nvim_get_mode().mode
  return '%#St_Mode#' .. string.format('  %s ', M.modes[m])
end

return M
