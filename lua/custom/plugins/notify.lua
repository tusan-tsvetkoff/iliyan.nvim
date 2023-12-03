return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")

    notify.setup({
      stages = "static",
      render = "compact",
      top_down = true,
    })

    vim.notify = notify
  end,
}
