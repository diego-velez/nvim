local todo = require 'todo-comments'
todo.setup {
  signs = true,
}

vim.keymap.set('n', '[t', todo.jump_prev, { desc = 'Previous [t]odo comment' })
vim.keymap.set('n', ']t', todo.jump_next, { desc = 'Next [t]odo comment' })
