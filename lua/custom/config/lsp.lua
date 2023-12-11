require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
  vimls = {},
  marksman = {},
  jsonls = {},
  lua_ls = {
    single_file_support = true,
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      completion = {
        callSnippet = 'Both',
        workspaceWord = true,
      },
      telemetry = {
        enable = false,
      },
      diagnostics = {
        disable = { 'missing-fields', 'trailing-space' },
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = 'Disable',
        semicolon = 'Disable',
        arrayIndex = 'Disable',
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = 'space',
          indent_size = 2,
          continuation_indent_size = 2,
        },
      },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup {}
local on_attach = require('custom.config.others').custom_on_attach

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

local lspconfig = require 'lspconfig'

mason_lspconfig.setup_handlers {
  function(server_name)
    lspconfig[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

require('rust-tools').setup {
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
  },
}
