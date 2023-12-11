local configure = function()
  local rose_pine = require 'rose-pine'

  rose_pine.setup {
    variant = 'main',
    disable_italics = true,
    bold_vert_split = true,
    disable_float_background = true,
    groups = {
      punctuation = 'muted',
    },
  }

  vim.cmd [[ colorscheme rose-pine ]]
end

return {
  'rose-pine/neovim',
  name = 'rose-pine',
  priority = 1000,
  config = configure,
}
