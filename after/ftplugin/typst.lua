vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

---Manages all the `typst watch` processes (value) per file (key)
---@type table<string, vim.SystemObj>
local processes = {}
local viewer = 'zathura'

---Manages all the stderr output (value) of a `typst watch` processes per file (key)
---@type table<string, table<string>>
local processStderr = {}

---@param file string
local function CloseProcess(file)
  local process = processes[file]
  if not process then
    vim.notify('There is no running preview for ' .. file, vim.log.levels.WARN)
    return
  end

  if not process:is_closing() then
    vim.notify('Closing preview for ' .. file, vim.log.levels.INFO)
    process:kill(3) -- SIGQUIT
    processes[file] = nil
    processStderr[file] = nil
  end
end

---@param file string
local function OnStderr(file)
  ---@param err string
  ---@param data string
  return function(err, data)
    if err ~= nil then
      vim.notify('Error running Typst watch for ' .. file, vim.log.levels.ERROR)
      CloseProcess(file)
      return
    end

    if string.find(data, 'error') then
      vim.notify('There was error compiling Typst for ' .. file)

      for _, line in ipairs(vim.split(data, '\n')) do
        table.insert(processStderr[file], line)
      end
    end
  end
end

local function ShowStderr()
  local file = vim.fn.expand '%:p'
  if processStderr[file] == nil then
    vim.notify('Typst preview for ' .. file .. ' not running', vim.log.levels.ERROR)
    return
  end

  vim.cmd.tabnew()

  local filetype = 'typst-log'

  local buf_id
  for _, id in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[id].filetype == filetype then
      buf_id = id
      break
    end
  end
  if buf_id == nil then
    buf_id = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(buf_id, 'Typst stderr for' .. file)
    vim.bo[buf_id].filetype = filetype
  end

  vim.api.nvim_buf_set_lines(buf_id, 0, -1, true, processStderr[file])

  vim.api.nvim_win_set_buf(0, buf_id)
end

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
    '--open',
    viewer,
    '--diagnostic-format',
    'short',
    file,
  }
  local process = vim.system(cmd, { text = true, stderr = OnStderr(file) })
  processes[file] = process
  processStderr[file] = {}
end

vim.api.nvim_create_autocmd('ExitPre', {
  group = vim.api.nvim_create_augroup('dvt typst', { clear = true }),
  desc = 'Close all running Typst previews',
  callback = function(_)
    for file, _ in pairs(processes) do
      CloseProcess(file)
    end
  end,
})

vim.keymap.set('n', '<leader>r', RunPreview, { buffer = 0, desc = '[R]un Preview in ' .. viewer })
vim.keymap.set('n', '<leader>tr', ShowStderr, { buffer = 0, desc = 'Toggle [R]un Output Buffer' })
