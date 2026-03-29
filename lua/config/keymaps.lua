vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<ESC>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keep cursor centered
vim.keymap.set('n', '<C-d>', function()
  vim.cmd.normal { '\4', bang = true }
  MiniAnimate.execute_after('scroll', 'normal! zz')
end)
vim.keymap.set('n', '<C-u>', function()
  vim.cmd.normal { '\21', bang = true }
  MiniAnimate.execute_after('scroll', 'normal! zz')
end)
vim.keymap.set('n', 'n', function()
  local succeeded = pcall(vim.cmd.normal, { 'n', bang = true })
  if succeeded then
    MiniAnimate.execute_after('scroll', 'normal! zzzv')
  end
end)
vim.keymap.set('n', 'N', function()
  local succeeded = pcall(vim.cmd.normal, { 'N', bang = true })
  if succeeded then
    MiniAnimate.execute_after('scroll', 'normal! zzzv')
  end
end)
vim.keymap.set('n', 'G', function()
  vim.cmd.normal { 'G', bang = true }
  MiniAnimate.execute_after('scroll', 'normal! zz')
end)

-- Paste linewise before/after current line
vim.keymap.set('n', '[p', '<cmd>exe "iput! " . v:register<CR>', { desc = 'Paste above' })
vim.keymap.set('n', ']p', '<cmd>exe "iput " . v:register<CR>', { desc = 'Paste below' })

-- Have cursor stay in place when joining lines together
vim.keymap.set('n', 'J', 'mzJ`z')

-- Stop automatically copying
vim.keymap.set('x', 'p', [["_dp]])
vim.keymap.set('n', 'C', '"_C')

-- Disable Q because apparently it's trash lmao
vim.keymap.set('n', 'Q', '<nop>')

-- Rename the word my cursor is on using vim's substitute thing
vim.keymap.set(
  'n',
  '<leader>cs',
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Rename using Vim's [S]ubstitution" }
)

-- Search visual selection
vim.keymap.set('x', '/', '<esc>/\\%V', { desc = 'Search visual selection' })

-- Commenting
vim.keymap.set(
  'n',
  'gco',
  'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>',
  { desc = 'Add Comment Below' }
)
vim.keymap.set(
  'n',
  'gcO',
  'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>',
  { desc = 'Add Comment Above' }
)

-- Tabs
vim.keymap.set('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
vim.keymap.set('n', '<leader><tab>w', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
vim.keymap.set('n', '<leader><tab>o', '<cmd>tabonly<cr>', { desc = 'Close [O]ther Tabs' })
vim.keymap.set('n', '<leader><tab>n', '<cmd>tabnext<cr>', { desc = '[N]ext Tab' })
vim.keymap.set('n', ']<tab>', '<cmd>tabnext<cr>', { desc = '[N]ext Tab' })
vim.keymap.set('n', '<leader><tab>p', '<cmd>tabprevious<cr>', { desc = '[P]revious Tab' })
vim.keymap.set('n', '[<tab>', '<cmd>tabprevious<cr>', { desc = '[P]revious Tab' })
vim.keymap.set('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = '[F]irst Tab' })
vim.keymap.set('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = '[L]ast Tab' })

-- [U]I keymaps
vim.keymap.set('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })
vim.keymap.set('n', '<leader>uI', function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input 'I'
end, { desc = 'Inspect Tree' })
vim.keymap.set(
  'n',
  '<leader>ur',
  '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>',
  { desc = '[R]edraw' }
)

-- Edit macros
vim.keymap.set(
  'n',
  '<leader>m',
  ":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>",
  { desc = 'Edit [M]acros' }
)

-- Use make by default
-- stylua: ignore
vim.keymap.set('n', '<leader>r', '<cmd>update<cr> <cmd>make<cr>', { desc = '[R]un file with :make' })

-- Delete line but leave an empty line
vim.keymap.set('n', 'X', '"_0D', { desc = 'Delete line but leave an empty line' })
