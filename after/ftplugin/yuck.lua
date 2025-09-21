---Checks if a specific EWW window is open or not
---@param window string The name of the EWW window to check for
---@return boolean
local function is_window_active(window)
  local out = vim.system({ 'eww', 'active-windows' }, { text = true }):wait()
  if out.code ~= 0 then
    error 'Could not get active windows for EWW'
  end
  return string.find(out.stdout, window) ~= nil
end

---Will open or close an EWW window
---@param window string The name of the EWW window to toggle
local function toggle_window(window)
  -- Check if window open or not
  local action = 'open'
  if is_window_active(window) then
    action = 'close'
  end

  -- Toggle the window accordingly
  local out = vim.system({ 'eww', action, window }, { text = true }):wait()
  if out.code ~= 0 then
    error('Could not ' .. action .. ' window:' .. window .. '\n' .. out.stderr)
  end
end

---Select a window from EWW, and open or close it
local function run_window()
  -- Get all windows for EWW
  local out = vim.system({ 'eww', 'list-windows' }, { text = true }):wait()
  if out.code ~= 0 then
    error('Failed to get windows for EWW\n' .. out.stderr)
  end

  -- Parse them into a table
  local windows = vim.split(out.stdout, '\n')
  windows = vim.tbl_filter(function(str)
    return #vim.trim(str) ~= 0
  end, windows)

  -- End of there are none
  if #windows == 0 then
    vim.notify('No windows available for EWW', vim.log.levels.WARN)
    return
  end

  -- Toggle the only one EWW window that exists
  if #windows == 1 then
    toggle_window(windows[1])
    return
  end

  vim.notify('No implementation to handle multiple EWW windows', vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>r', run_window, { buffer = 0, desc = 'Toggle EWW window' })
