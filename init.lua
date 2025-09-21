require 'config.keymaps'
require 'config.options'
require 'config.autocmds'

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath 'data' .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.uv.fs_stat(mini_path) then
  vim.notify('Installing mini.nvim', vim.log.levels.INFO)
  vim.cmd.redraw()

  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/nvim-mini/mini.nvim',
    mini_path,
  }
  local out = vim.system(clone_cmd, { text = true }):wait()

  if out.code ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone mini.nvim:\n', 'ErrorMsg' },
      { out.stderr, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    return
  end

  vim.cmd 'packadd mini.nvim | helptags ALL'
  vim.notify('Installed mini.nvim', vim.log.levels.INFO)
  vim.cmd.redraw()
end

require('mini.deps').setup { path = { package = path_package } }

require 'plugins'
