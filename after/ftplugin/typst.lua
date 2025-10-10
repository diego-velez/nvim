vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

---Manages all the `typst watch` processes (value) per file (key)
---@type vim.SystemObj[]
local processes = {}
local viewer = 'zathura'

local function RunPreview()
  local file = vim.fn.expand '%:p'
  if processes[file] ~= nil then
    vim.notify('Preview already running!', vim.log.levels.WARN)
    return
  end

  vim.notify('Launching preview for ' .. file, vim.log.levels.INFO)
  local cmd = {
    'typst',
    'watch',
    file,
    '--open',
    viewer,
  }
  local process = vim.system(cmd)
  processes[file] = process
end

vim.api.nvim_create_autocmd('ExitPre', {
  group = vim.api.nvim_create_augroup('dvt typst', { clear = true }),
  desc = 'Close all running Typst previews',
  callback = function(_)
    for file, process in pairs(processes) do
      if not process:is_closing() then
        vim.notify('Closing preview for ' .. file, vim.log.levels.INFO)
        process:kill(3) -- SIGQUIT
      end
    end
  end,
})

vim.keymap.set('n', '<leader>r', RunPreview, { buffer = 0, desc = '[R]un Preview in ' .. viewer })
