require('grug-far').setup {
  keymaps = {
    replace = { n = '<localleader>r' },
    qflist = { n = '<localleader>q' },
    syncLocations = { n = '<localleader>s' },
    syncLine = { n = '<localleader>l' },
    close = { n = '<localleader>c' },
    historyOpen = { n = '<localleader>t' },
    historyAdd = { n = '<localleader>a' },
    refresh = { n = '<localleader>f' },
    openLocation = { n = '<localleader>o' },
    openNextLocation = { n = '<down>' },
    openPrevLocation = { n = '<up>' },
    gotoLocation = { n = '<enter>' },
    pickHistoryEntry = { n = '<enter>' },
    abort = { n = '<localleader>b' },
    help = { n = 'g?' },
    toggleShowCommand = { n = '<localleader>w' },
    swapEngine = { n = '<localleader>e' },
    previewLocation = { n = '<localleader>i' },
    swapReplacementInterpreter = { n = '<localleader>x' },
    applyNext = { n = '<localleader>j' },
    applyPrev = { n = '<localleader>k' },
    syncNext = { n = '<localleader>n' },
    syncPrev = { n = '<localleader>p' },
    syncFile = { n = '<localleader>v' },
    nextInput = { n = '<tab>', i = '<down>' },
    prevInput = { n = '<s-tab>', i = '<up>' },
  },
}

vim.keymap.set('n', '<leader>sR', function()
  local grug = require 'grug-far'
  local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
  grug.open {
    transient = true,
    prefills = { filesFilter = ext and ext ~= '' and '*.' .. ext or nil },
  }
end, { desc = '[S]earch and [R]eplace' })
