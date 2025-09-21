vim.opt_local.makeprg = 'lua %'

local function run_lua()
  local filepath = vim.fn.expand '%:p'
  local config_path = vim.fn.stdpath 'config'
  local rel_path = vim.fs.relpath(config_path, filepath)

  local in_nvim_config = rel_path ~= nil
  if in_nvim_config then
    vim.notify('Sourcing current file', vim.log.levels.INFO)
    return '<cmd>source %<cr>'
  end

  -- Standard <leader>r keymap as defined in keymaps.lua
  return '<cmd>update<cr> <cmd>make<cr>'
end

vim.keymap.set(
  'n',
  '<leader>r',
  run_lua,
  { buffer = 0, expr = true, desc = 'Source/Run Current File' }
)
