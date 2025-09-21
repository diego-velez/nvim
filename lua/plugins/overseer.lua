require('overseer').setup {
  templates = {
    'builtin',
    'java',
    'skaffold',
  },
  dap = false,
  task_list = {
    bindings = {
      ['?'] = 'ShowHelp',
      ['g?'] = 'ShowHelp',
      ['<CR>'] = 'RunAction',
      ['<C-e>'] = 'Edit',
      ['o'] = 'Open',
      ['<C-v>'] = 'OpenVsplit!',
      ['<C-h>'] = 'OpenSplit',
      ['<C-f>'] = 'OpenFloat',
      ['<C-q>'] = 'OpenQuickFix',
      ['p'] = 'TogglePreview',
      ['<C-right>'] = false,
      ['<C-left>'] = false,
      ['<C-down>'] = 'IncreaseAllDetail',
      ['<C-up>'] = 'DecreaseAllDetail',
      ['{'] = 'DecreaseWidth',
      ['}'] = 'IncreaseWidth',
      ['['] = 'PrevTask',
      [']'] = 'NextTask',
      ['<C-u>'] = 'ScrollOutputUp',
      ['<C-d>'] = 'ScrollOutputDown',
      ['q'] = 'Close',
    },
  },
  form = {
    win_opts = {
      winblend = 0,
    },
  },
  confirm = {
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

vim.keymap.set('n', '<leader>ow', '<cmd>OverseerToggle<cr>', { desc = 'Task list' })
vim.keymap.set('n', '<leader>oo', '<cmd>OverseerRun<cr>', { desc = 'Run task' })
vim.keymap.set('n', '<leader>oq', '<cmd>OverseerQuickAction<cr>', { desc = 'Action recent task' })
vim.keymap.set('n', '<leader>oi', '<cmd>OverseerInfo<cr>', { desc = 'Overseer Info' })
vim.keymap.set('n', '<leader>ob', '<cmd>OverseerBuild<cr>', { desc = 'Task builder' })
vim.keymap.set('n', '<leader>ot', '<cmd>OverseerTaskAction<cr>', { desc = 'Task action' })
vim.keymap.set('n', '<leader>oc', '<cmd>OverseerClearCache<cr>', { desc = 'Clear cache' })
