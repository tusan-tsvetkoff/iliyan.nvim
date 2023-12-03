local key = vim.keymap

-- SSR Maps
key.set({ 'n', 'x' }, "<leader>sr", function() require("ssr").open() end)

-- Incr Rename
key.set('n', '<leader>rr', ':IncRename ')
-- this is for the clipboard stuff, not using it rn
-- key.set({ "n", "v" }, "<leader>y", [["+y]])
-- key.set("n", "<leader>Y", [["+Y]])

-- paste man
key.set("x", "<leader>p", [["_dP]])

-- moving lines
key.set("v", "J", ":m '>+1<CR>gv=gv")
key.set("v", "K", ":m '<-2<CR>gv=gv")

key.set('n', 'Q', '<nop>')

-- cursor positioning while moving
key.set("n", "J", "mzJ`z")
key.set("n", "<C-d>", "<C-d>zz")
key.set("n", "<C-u>", "<C-u>zz")
key.set("n", "n", "nzzzv")
key.set("n", "N", "Nzzzv")

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

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
key.set('n', '<C-h>', '<Cmd>Neotree toggle<CR>')


-- Insert Mode (from @chrisgrieser)
key.set('i', "<C-e>", "<Esc>A") -- EoL
key.set('i', "<C-a>", "<Esc>I") -- BoL

key.set('n', 'i', function()
    if vim.api.nvim_get_current_line():find("^%s*$") then return [["_cc]] end
    return 'i'
end, { expr = true, desc = "Better i" })
