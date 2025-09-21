-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Smart cursor line
local smart_cursor = vim.api.nvim_create_augroup('Smart cursor', { clear = true })
vim.api.nvim_create_autocmd('InsertLeave', {
  group = smart_cursor,
  command = 'set cursorline',
})

vim.api.nvim_create_autocmd('InsertEnter', {
  group = smart_cursor,
  command = 'set nocursorline',
})

vim.api.nvim_create_autocmd('FocusGained', {
  group = vim.api.nvim_create_augroup('Update file on change', { clear = true }),
  desc = 'Update file when it changes',
  command = 'checktime',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('Enable wrap/spell', { clear = true }),
  desc = 'Enable wrap and spell in these filetypes',
  pattern = { 'gitcommit', 'markdown', 'text', 'log', 'typst' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd('BufReadPre', {
  group = vim.api.nvim_create_augroup('Clear search', { clear = true }),
  desc = 'Clear the last used search pattern when opening a new buffer',
  pattern = '*',
  callback = function()
    vim.fn.setreg('/', '') -- Clears the search register
    vim.cmd 'let @/ = ""' -- Clear the search register using Vim command
  end,
})

vim.api.nvim_create_autocmd('WinResized', {
  group = vim.api.nvim_create_augroup('Smart scrolloff', { clear = true }),
  desc = 'Automatically adjust scrolloff based on window size',
  callback = function()
    local percentage = 0.16
    local percentage_lines = math.floor(vim.o.lines * percentage)
    local max_lines = 10
    vim.o.scrolloff = math.min(max_lines, percentage_lines)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('Remap q to close buf for some filetypes', { clear = true }),
  pattern = { 'checkhealth', 'help', 'lspinfo', 'qf', 'git', 'oil', 'trouble' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false

    local close_buffer = vim.schedule_wrap(function()
      vim.cmd 'close'
      pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
    end)

    ---@type vim.keymap.set.Opts
    local keymap_opts = { buffer = event.buf, silent = true, desc = 'Close buffer', nowait = true }

    vim.keymap.set('n', 'q', close_buffer, keymap_opts)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('Auto close quickfix', { clear = true }),
  desc = 'Automatically close quickfix list after selecting an entry',
  pattern = 'qf',
  callback = function(event)
    vim.keymap.set('n', '<CR>', '<CR><CMD>cclose<CR>', { buffer = event.buf })
  end,
})
