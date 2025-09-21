require('yanky').setup {
  highlight = {
    timer = 150,
  },
}

-- stylua: ignore start
vim.keymap.set({'n','x'}, '<leader>p', vim.cmd.YankyRingHistory, { desc = 'Open Yank History' })
vim.keymap.set({'n','x'}, 'y', '<Plug>(YankyYank)', { desc = 'Yank Text' })
vim.keymap.set({'n','x'}, 'p', '<Plug>(YankyPutAfter)', { desc = 'Put Text After Cursor' })
vim.keymap.set({'n','x'}, 'P', '<Plug>(YankyPutBefore)', { desc = 'Put Text Before Cursor' })
vim.keymap.set({'n','x'}, 'gp', '<Plug>(YankyGPutAfter)', { desc = 'Put Text After Selection' })
vim.keymap.set({'n','x'}, 'gP', '<Plug>(YankyGPutBefore)', { desc = 'Put Text Before Selection' })
vim.keymap.set('n', '[y', '<Plug>(YankyCycleForward)', { desc = 'Cycle Forward Through Yank History' })
vim.keymap.set('n', ']y', '<Plug>(YankyCycleBackward)', { desc = 'Cycle Backward Through Yank History' })
vim.keymap.set('n', ']p', '<Plug>(YankyPutIndentAfterLinewise)', { desc = 'Paste after line' })
vim.keymap.set('n', '[p', '<Plug>(YankyPutIndentBeforeLinewise)', { desc = 'Paste before line' })
vim.keymap.set('n', ']P', '<Plug>(YankyPutIndentAfterLinewise)', { desc = 'Paste after line' })
vim.keymap.set('n', '[P', '<Plug>(YankyPutIndentBeforeLinewise)', { desc = 'Paste before line' })
-- stylua: ignore end
