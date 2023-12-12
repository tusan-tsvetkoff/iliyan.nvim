-- Rose Pine
---@diagnostic disable-next-line: unused-function, unused-local
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
end

local configure_tokyo_night = function()
  local tokyo_night = require 'tokyonight'
  tokyo_night.setup {
    on_highlights = function(hl, c)
      local prompt = '#2d3149'
      hl.TelescopeNormal = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      }
      hl.TelescopeBorder = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
      hl.TelescopePromptNormal = {
        bg = prompt,
      }
      hl.TelescopePromptBorder = {
        bg = prompt,
        fg = prompt,
      }
      hl.TelescopePromptTitle = {
        bg = prompt,
        fg = prompt,
      }
      hl.TelescopePreviewTitle = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
      hl.TelescopeResultsTitle = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
    end,
    style = 'storm',
    terminal_colors = true,
    styles = {
      comments = { italic = false },
      keywords = { italic = false },
      functions = { bold = true },
    },
  }
  vim.cmd [[ colorscheme tokyonight ]]
end

return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = configure_tokyo_night,
}
