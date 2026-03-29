_G.Config = {}

vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }

-- stylua: ignore start
local misc = require('mini.misc')
Config.now = function(f) misc.safely('now', f) end
Config.later = function(f) misc.safely('later', f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
-- stylua: ignore end

Config.now(function()
  require 'config.check_dotfile_cwd'
end)

Config.now(function()
  require 'config.keymaps'
end)

Config.now(function()
  require 'config.options'
end)

Config.now(function()
  require 'config.autocmds'
end)

Config.now(function()
  require 'plugins'
end)
