local autocmd = vim.api.nvim_create_autocmd
local opt_local = vim.opt_local
------------------------Autocommands--------------------------
-- Stop auto newline continuation of comments
autocmd('FileType', {
    callback = function()
        opt_local.formatoptions:remove 'o'
    end,
})

-- Notify when coming back to a file that does not exist anymore
autocmd('FocusGained', {
    callback = function()
        ---@diagnostic disable-next-line: param-type-mismatch
        local fileExists = vim.loop.fs_stat(vim.fn.expand '%') ~= nil
        local specialBuffer = vim.bo.buftype ~= ''
        if not fileExists and not specialBuffer then
            vim.notify('File does not exist anymore.', vim.log.levels.WARN, { timeout = 20000 })
        end
    end,
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
    callback = function()
        local ok, cl = pcall(vim.api.nvim_win_get_var, 0, 'auto-cursorline')
        if ok and cl then
            vim.wo.cursorline = true
            vim.api.nvim_win_del_var(0, 'auto-cursorline')
        end
    end,
})
vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
    callback = function()
        local cl = vim.wo.cursorline
        if cl then
            vim.api.nvim_win_set_var(0, 'auto-cursorline', cl)
            vim.wo.cursorline = false
        end
    end,
})

-- create directories when needed, when saving a file
vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('better_backup', { clear = true }),
    callback = function(event)
        local file = vim.loop.fs_realpath(event.match) or event.match
        local backup = vim.fn.fnamemodify(file, ':p:~:h')
        backup = backup:gsub('[/\\]', '%%')
        vim.go.backupext = backup
    end,
})

local set_hl_for_floating_window = function()
    vim.api.nvim_set_hl(0, 'NormalFloat', {
        link = 'Normal',
    })
    vim.api.nvim_set_hl(0, 'FloatBorder', {
        bg = 'none',
    })
end

autocmd('ColorScheme', {
    pattern = '*',
    desc = 'Avoid overwritten by loading color schemes later',
    callback = set_hl_for_floating_window,
})

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', {
    clear = true,
})

autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})
