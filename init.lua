_G.Config = {}

vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }

-- stylua: ignore start
local misc = require('mini.misc')
Config.now = function(f) misc.safely('now', f) end
Config.later = function(f) misc.safely('later', f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.later_if_args = vim.fn.argc(-1) > 0 and Config.later or Config.now
-- stylua: ignore end

-- Project local .init.lua for predefined project marks
vim.o.exrc = true
vim.o.secure = true -- Must run `:trust` to mark file as trusted
