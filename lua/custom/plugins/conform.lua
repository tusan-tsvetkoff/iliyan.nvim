return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo ' },
  opts = {
    log_level = vim.log.levels.TRACE,
    formatters_by_ft = {
      lua = { 'stylua' },
      json = { 'prettierd', 'prettier' },
      markdown = { 'prettierd', 'prettier' },
      cs = { 'csharpier' },
    },
    formatters = {
      csharpier = {
        command = 'dotnet-csharpier',
        args = { '--write-stdout' },
      },
    },
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
  },
}
