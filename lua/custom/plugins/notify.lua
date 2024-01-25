return {
  'rcarriga/nvim-notify',
  config = function()
    local notify = require 'notify'

    notify.setup {
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
      stages = 'fade_in_slide_out',
      timeout = 3000,
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
