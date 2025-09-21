require('no-neck-pain').setup {
  width = 115,
  disableOnLastBuffer = true,
  autocmds = {
    enableOnVimEnter = 'safe',
    skipEnteringNoNeckPainBuffer = true,
  },
}

vim.keymap.set('n', '<leader>tn', '<cmd>NoNeckPain<cr>', { desc = 'Toggle No [N]eck Pain' })
