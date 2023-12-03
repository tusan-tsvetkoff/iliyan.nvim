local keymap = vim.keymap
local fn = vim.fn
local u = require("custom.config.utils")

-------------------------------------------------------------------------------
-- Paste non-linewise text above or below current line
-- see https://stackoverflow.com/a/1346777/6064933
keymap.set("n", "<leader>p", "m`o<ESC>p``", { desc = "Paste below current line" })
keymap.set("n", "<leader>P", "m`O<ESC>p``", { desc = "Paste above current line" })

-- SSR Maps
keymap.set({ 'n', 'x' }, "<leader>sr", function() require("ssr").open() end)

-- copy [l]ast ex[c]ommand
keymap.set("n", "<leader>lc", function()
    local lastCommand = fn.getreg(":")
    if lastCommand == "" then
        vim.notify("No last command available", u.warn)
        return
    end
    fn.setreg("+", lastCommand)
    vim.notify("COPIED\n" .. lastCommand)
end, { desc = "󰘳 Copy last command" })

-- Incr Rename
keymap.set('n', '<leader>rr', ':IncRename ')
-- this is for the clipboard stuff, not using it rn
-- key.set({ "n", "v" }, "<leader>y", [["+y]])
-- key.set("n", "<leader>Y", [["+Y]])

-- Keys are too damn hard to press
keymap.set('n', '<leader>bl', '^', { desc = "Move to beginning of line" })
keymap.set('n', '<leader>el', '$', { desc = "Move to beginning of line" })

keymap.set("n", "~", "~h", { desc = "~ without moving)" })

-- paste man
keymap.set("x", "<leader>p", [["_dP]])

-- moving lines
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Easier upper/lower case
keymap.set('n', '<leader>u', 'gUiw', { desc = "Upper case word" })
keymap.set('n', '<leader>l', 'guiw', { desc = "Lower case word" })

keymap.set('n', 'Q', '<nop>')

-- Keep cursor centered
keymap.set("n", "J", "mzJ`z")

-- Repeated V selects more lines
keymap.set("x", "V", "j", { desc = "Repeated V selects more lines" })

-- Cursor positioning while moving
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
    { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
    { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,
    { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,
    { desc = 'Open diagnostics list' })

-- Neotree
-- keymap.set('n', '<C-h>', '<Cmd>Neotree toggle<CR>')

-- Insert Mode (from @chrisgrieser)
keymap.set('i', "<C-e>", "<Esc>A") -- EoL
keymap.set('i', "<C-a>", "<Esc>I") -- BoL

keymap.set('n', 'i', function()
    if vim.api.nvim_get_current_line():find("^%s*$") then return [["_cc]] end
    return 'i'
end, { expr = true, desc = "Better i" })


--- A lot of these are taken from @chrisgrieser, @folke, @jdhao and @theprimeagen
