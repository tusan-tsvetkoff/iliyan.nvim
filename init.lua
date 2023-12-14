vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  'jmederosalvarado/roslyn.nvim',
  { 'Hoffs/omnisharp-extended-lsp.nvim', lazy = true },
  -- Modern matchit implementation

  { 'cespare/vim-toml', ft = { 'toml' }, branch = 'main' },

  {
    'folke/which-key.nvim',
    opts = {},
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '\u{258B}' },
        change = { text = '\u{258B}' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '\u{258B}' },
        untracked = { text = '\u{258B}' },
      },
      numhl = false, -- Enable hl for line numbers
      linehl = false, -- Disable the signs column highlight
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, {
          buffer = bufnr,
          desc = 'Preview git hunk',
        })

        local present_scrollbar = pcall(require, 'scrollbar')
        if present_scrollbar then
          require('scrollbar.handlers.gitsigns').setup()
        end

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, {
          expr = true,
          buffer = bufnr,
          desc = 'Jump to next hunk',
        })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, {
          expr = true,
          buffer = bufnr,
          desc = 'Jump to previous hunk',
        })
      end,
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
  },
  {
    'numToStr/Comment.nvim',
    opts = {},
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        },
      }
    end,
  },
  require 'kickstart.plugins.autoformat',
  {
    import = 'custom.plugins',
  },
}, {})

require 'custom.config.init'

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = {
    name = '[C]ode',
    _ = 'which_key_ignore',
  },
  ['<leader>d'] = {
    name = '[D]ocument',
    _ = 'which_key_ignore',
  },
  ['<leader>g'] = {
    name = '[G]it',
    _ = 'which_key_ignore',
  },
  ['<leader>h'] = {
    name = 'More git',
    _ = 'which_key_ignore',
  },
  ['<leader>r'] = {
    name = '[R]ename',
    _ = 'which_key_ignore',
  },
  ['<leader>s'] = {
    name = '[S]earch',
    _ = 'which_key_ignore',
  },
  ['<leader>w'] = {
    name = '[W]orkspace',
    _ = 'which_key_ignore',
  },
}

require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
  -- omnisharp = {},
  vimls = {},
  marksman = {},
  jsonls = {
    -- on_new_config = function(new_config)
    --   new_config.settings.json.schemas = new_config.settings.json.schemas or {}
    --   vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
    -- end,
    settings = {
      json = {
        format = {
          enable = true,
        },
        validate = { enable = true },
      },
    },
  },
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
        globals = { 'vim' },
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

require('barbecue').setup {}

-- Setup neovim lua configuration
require('neodev').setup {}
local custom_on_attach = require('custom.config.others').custom_on_attach

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
      on_attach = custom_on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
  ['omnisharp'] = function()
    lspconfig['omnisharp'].setup {
      on_attach = custom_on_attach,
      capabilities = capabilities,
      root_dir = function(fname)
        local primary = lspconfig.util.root_pattern '*.sln'(fname)
        local fallback = lspconfig.util.root_pattern '*.csproj'(fname)
        return primary or fallback
      end,
      on_new_config = function(new_config, new_root_dir)
        if new_root_dir then
          table.insert(new_config.cmd, '-z') -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
          vim.list_extend(new_config.cmd, { '-s', new_root_dir })
          vim.list_extend(new_config.cmd, { '--hostPID', tostring(vim.fn.getpid()) })
          table.insert(new_config.cmd, 'DotNet:enablePackageRestore=false')
          vim.list_extend(new_config.cmd, { '--encoding', 'utf-8' })
          table.insert(new_config.cmd, '--languageserver')

          if new_config.enable_editorconfig_support then
            table.insert(new_config.cmd, 'FormattingOptions:EnableEditorConfigSupport=true')
          end

          if new_config.organize_imports_on_format then
            table.insert(new_config.cmd, 'FormattingOptions:OrganizeImports=true')
          end

          if new_config.enable_ms_build_load_projects_on_demand then
            table.insert(new_config.cmd, 'MsBuild:LoadProjectsOnDemand=true')
          end

          if new_config.enable_roslyn_analyzers then
            table.insert(new_config.cmd, 'RoslynExtensionsOptions:EnableAnalyzersSupport=true')
          end

          if new_config.enable_import_completion then
            table.insert(new_config.cmd, 'RoslynExtensionsOptions:EnableImportCompletion=true')
          end

          if new_config.sdk_include_prereleases then
            table.insert(new_config.cmd, 'Sdk:IncludePrereleases=true')
          end

          if new_config.analyze_open_documents_only then
            table.insert(new_config.cmd, 'RoslynExtensionsOptions:AnalyzeOpenDocumentsOnly=true')
          end
        end
      end,
      -- handlers = vim.tbl_extend('force', rounded_border_handlers, {
      --   ['textDocument/definition'] = require('omnisharp_extended').handler,
      -- }),
    }
  end,
}

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    local neodev = require 'neodev'
    neodev.setup {
      library = {
        plugins = {
          'nvim-dap-ui',
          types = true,
        },
      },
    }
  end,
})

require('rust-tools').setup {
  server = {
    on_attach = custom_on_attach,
    capabilities = capabilities,
  },
}
require('roslyn').setup {
  dotnet_cmd = 'dotnet', -- this is the default
  roslyn_version = '4.8.0-3.23475.7', -- this is the default
  on_attach = custom_on_attach,
  capabilities = capabilities,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
