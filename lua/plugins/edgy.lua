require('edgy').setup {
  bottom = {
    'Trouble',
    { ft = 'qf', title = 'QuickFix' },
    {
      title = 'Overseer Output',
      ft = 'OverseerListOutput',
    },
    { title = 'Neotest Output', ft = 'neotest-output-panel', size = { height = 15 } },
    { title = 'Undo Tree Diff', ft = 'diff', size = { height = 15 } },
    {
      title = 'Kulala',
      ft = 'json.kulala_ui',
    },
    {
      title = 'Kulala',
      ft = 'text.kulala_ui',
    },
  },
  left = {
    { title = 'Neotest Summary', ft = 'neotest-summary' },
    { title = 'Undo Tree', ft = 'undotree' },
  },
  right = {
    {
      title = 'Grug Far',
      ft = 'grug-far',
      size = { width = 0.3 },
    },
    {
      title = 'Overseer',
      ft = 'OverseerList',
    },
  },
  keys = {
    ['q'] = false,
    ['<c-q>'] = false,
    ['Q'] = false,
    [']w'] = false,
    ['[w'] = false,
    [']W'] = false,
    ['[W'] = false,
    ['<c-w>>'] = false,
    ['<c-w><lt>'] = false,
    ['<c-w>+'] = false,
    ['<c-w>-'] = false,
    ['<c-w>='] = false,
  },
}
