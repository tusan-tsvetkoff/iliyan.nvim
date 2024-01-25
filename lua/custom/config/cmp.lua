local cmp = require 'cmp'
local luasnip = require 'luasnip'
local cmp_kinds = require('custom.plugins.utils.icons').cmp_kinds
local field_arrangement = { 'abbr', 'kind', 'menu' }

-- gray
vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
-- blue
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
-- light blue
vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
-- pink
vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
-- front
vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#D4D4D4' })
vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })

local format_style = {
  fields = field_arrangement,
  format = function(entry, vim_item)
    local lspkind_ok, lspkind_f = pcall(require, 'lspkind')
    if not lspkind_ok then
      if entry.source.name == 'Copilot' then
        vim_item.kind = cmp_kinds[entry.kind]
      end
      vim_item.kind = string.format('%s %s', cmp_kinds[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      -- Source
      vim_item.menu = ({
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        luasnip = '[LuaSnip]',
        nvim_lua = '[Lua]',
        latex_symbols = '[LaTeX]',
      })[entry.source.name]
      return vim_item
    else
      -- From lspkind
      lspkind_f.init {
        mode = 'symbol_text',
        symbol_map = {
          Copilot = '',
        },
      }
      vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' })
      return lspkind_f.cmp_format()(entry, vim_item)
    end
  end,
}

-- local function border(hl_name)
--   return {
--     { '╭', hl_name },
--     { '─', hl_name },
--     { '╮', hl_name },
--     { '│', hl_name },
--     { '╯', hl_name },
--     { '─', hl_name },
--     { '╰', hl_name },
--     { '│', hl_name },
--   }
-- end

local options = {
  vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true }),
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  experimental = {
    ghost_text = {
      hl_group = 'CmpGhostText',
    },
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      require('copilot_cmp.comparators').prioritize,
      -- Below is the default comparitor list and order for nvim-cmp
      cmp.config.compare.offset, -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  completion = {
    completeopt = 'menu,menuone,noinsert',
  },

  -- window = {
  --   completion = {
  --     scrollbar = false,
  --     border = border 'CmpDscBorder',
  --   },
  --   documentation = {
  --     border = border 'CmpDscBorder',
  --     winhighlight = 'Normal:CmpDoc',
  --   },
  -- },

  -- `/` cmdline setup.
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    },
  }),

  -- `:` cmdline setup.
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline', option = {
        ignore_cmds = { 'w' },
      } },
    }),
  }),

  sources = {
    {
      name = 'nvim_lsp_signature_help',
    },
    {
      name = 'copilot',
      priority = 100,
      group_index = 1,
    },
    {
      name = 'nvim_lsp',
    },
    {
      name = 'luasnip',
    },
    {
      name = 'emoji',
      insert = true,
    },
    {
      name = 'nvim_lua',
    },
    {
      name = 'path',
    },
    {
      name = 'buffer',
      keyword_length = 3,
    },
  },
  formatting = format_style,

  -- {
  -- -- fields = field_arrangement,
  -- format = lspkind.cmp_format({
  --     menu = ({
  --         buffer = "[Buffer]",
  --         nvim_lsp = "[LSP]",
  --         luasnip = "[LuaSnip]",
  --         nvim_lua = "[Lua]",
  --         emoji = "[Emoji]",
  --         path = "[Path]",
  --         copilot = "[Copilot]"
  --     }),
  --     mode = "symbol_text",
  --     max_width = 50,
  --     symbol_map = {
  --         Copilot = ''
  --     }
  -- })
  -- },

  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.scroll_docs(-4),
    ['<C-k>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item {
          behavior = cmp.SelectBehavior.Select,
        }
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
}

return options
