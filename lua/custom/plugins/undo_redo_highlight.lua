return {
  "tzachar/highlight-undo.nvim",
  keys = { "u", "U" },
  opts = {
    duration = 250,
    undo = {
      lhs = "u",
      map = "silent undo",
      opts = { desc = "󰕌 Undo" },
    },
    redo = {
      lhs = "U",
      map = "silent redo",
      opts = { desc = "󰑎 Redo" },
    },
  },
}
