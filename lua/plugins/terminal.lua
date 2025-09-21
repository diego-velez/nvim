require('floaterm').setup {
  size = {
    h = 80,
    w = 80,
  },
  mappings = {
    term = function(buf)
      vim.keymap.set({ 'n', 't' }, '<C-n>', function()
        require('floaterm.api').cycle_term_bufs 'next'
      end, { desc = 'Move to next terminal', buffer = buf })

      vim.keymap.set({ 'n', 't' }, '<C-p>', function()
        require('floaterm.api').cycle_term_bufs 'prev'
      end, { desc = 'Move to previous terminal', buffer = buf })

      vim.keymap.set({ 'n', 't' }, '<C-e>', function()
        require('floaterm.api').switch_wins()
      end, { desc = 'Switch to terminals window', buffer = buf })

      vim.keymap.set(
        { 'n', 't' },
        '<C-/>',
        '<cmd>FloatermToggle<cr>',
        { desc = 'Toggle terminal', buffer = buf }
      )
    end,
  },
}

vim.keymap.set('n', '<C-/>', '<cmd>FloatermToggle<cr>', { desc = 'Toggle floating terminal' })
