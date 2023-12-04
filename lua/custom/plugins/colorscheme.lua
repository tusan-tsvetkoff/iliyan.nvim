return {
  'ellisonleao/gruvbox.nvim',

  priority = 1000,
  config = function()
    local gruvbox = require('gruvbox')
    gruvbox.setup({
      italics = {
        strings = false,
        comments = true,
        keywords = false,
        functions = false,
        variables = false,
      },
      contrast = "",
      overrides = {
        SignColumn = {
          bg = "#282828",
        },
      }
    })
  end,
}
