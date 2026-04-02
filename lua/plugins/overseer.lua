require('overseer').setup {
  templates = {
    'builtin',
    'mise',
    'java',
    'skaffold',
  },
  dap = false,
  form = {
    win_opts = {
      winblend = 0,
    },
  },
  task_win = {
    win_opts = {
      winblend = 0,
    },
  },
}

local map = function(lhs, rhs, desc)
  vim.keymap.set('n', '<leader>' .. lhs, '<cmd>' .. rhs .. '<cr>', { desc = desc })
end

map('ow', 'OverseerToggle', 'Task list')
map('oo', 'OverseerRun', 'Run task')
map('ot', 'OverseerTaskAction', 'Task action')
map('os', 'OverseerShell', 'Run shell command')
