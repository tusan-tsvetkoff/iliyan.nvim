return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo ' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      json = { 'prettierd', 'prettier' },
      markdown = { 'prettierd', 'prettier' },
    },
    format_on_save = { timeout_ms = 500, lsp_fallback = true }
  },
}
