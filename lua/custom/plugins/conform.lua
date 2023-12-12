return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo ' },
  opts = {
    format = {
      timeout_ms = 3000,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
    },
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
    format_on_save = { timeout_ms = 3000, lsp_fallback = true },
  },
}
