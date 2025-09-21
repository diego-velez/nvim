local spear = require 'spear'
spear.setup()

-- stylua: ignore
vim.keymap.set('n', '<leader>la', spear.add, { desc = '[A]dd file to list' })
vim.keymap.set('n', '<leader>ld', spear.remove, { desc = '[D]elete file from list' })
vim.keymap.set('n', '<leader>lD', spear.delete, { desc = '[D]elete list' })
vim.keymap.set('n', '<leader>lc', spear.create, { desc = '[C]reate list' })
vim.keymap.set('n', '<leader>lr', spear.rename, { desc = '[R]ename list' })
vim.keymap.set('n', '<leader>ls', spear.switch, { desc = '[S]witch list' })
vim.keymap.set('n', '<leader>lu', require('spear.ui').open, { desc = 'Spear UI' })

vim.keymap.set('n', '<A-n>', function()
  require('spear').select(1)
end)
vim.keymap.set('n', '<A-e>', function()
  require('spear').select(2)
end)
vim.keymap.set('n', '<A-i>', function()
  require('spear').select(3)
end)
vim.keymap.set('n', '<A-o>', function()
  require('spear').select(4)
end)
