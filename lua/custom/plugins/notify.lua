return {
  'rcarriga/nvim-notify',
  config = function()
    local notify = require 'notify'

    notify.setup {
      stages = 'fade_in_slide_out',
      timeout = 1500,
      render = 'compact',
      top_down = true,
      window = {
        opacity = {
          10,
          8,
          6,
          4,
          2,
        },
      },
    }

    vim.notify = notify
  end,
}
