vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end
local xmap = function(lhs, rhs, desc)
  vim.keymap.set('x', lhs, rhs, { desc = desc })
end

-- Clear highlights on search when pressing <Esc> in normal mode
nmap('<ESC>', '<cmd>nohlsearch<CR>')

-- Keep cursor centered
local move_cursor = function(lhs, norm_lhs, ex_after)
  nmap(lhs, function()
    local succeded = pcall(vim.cmd.normal, { norm_lhs, bang = true })
    if succeded then
      MiniAnimate.execute_after('scroll', 'normal! ' .. ex_after)
    end
  end)
end

move_cursor('<C-d>', '\4', 'zz')
move_cursor('<C-u>', '\21', 'zz')
move_cursor('n', 'n', 'zzzv')
move_cursor('N', 'N', 'zzzv')

-- Notifications
nmap('<leader>n', '<cmd>lua MiniNotify.show_history()<cr>', '[N]otification History')

-- Paste linewise before/after current line
nmap('[p', '<cmd>exe "iput! " . v:register<CR>', 'Paste above')
nmap(']p', '<cmd>exe "iput " . v:register<CR>', 'Paste below')

-- Have cursor stay in place when joining lines together
nmap('J', 'mzJ`z')

-- Stop automatically copying
vim.keymap.set('x', 'p', [["_dP]])
nmap('C', '"_C')

-- Disable Q because apparently it's trash lmao
nmap('Q', '<nop>')

-- Rename the word my cursor is on using vim's substitute thing
nmap(
  '<leader>cs',
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  "Rename using Vim's [S]ubstitution"
)

-- Search visual selection
xmap('/', '<esc>/\\%V', 'Search visual selection')

-- Commenting
nmap('gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', 'Add Comment Below')
nmap('gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', 'Add Comment Above')

-- b is for 'buffer'.
local new_scratch_buffer = function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end
nmap('<leader>bn', new_scratch_buffer, 'New Buffer')
nmap('<leader>bd', '<cmd>lua MiniBufremove.delete()<cr>', 'Delete Buffer')
nmap('<leader>ba', '<cmd>b#<cr>', 'Alternate Buffer')

-- u is for 'UI'.
nmap('<leader>ui', '<cmd>Inspect<cr>', 'Inspect Pos')
nmap('<leader>uI', '<cmd>InspectTree<cr>', 'Inspect Tree')
nmap('<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', '[R]edraw')

-- Edit macros
nmap(
  '<leader>m',
  ":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>",
  'Edit [M]acros'
)

-- Use make by default
-- stylua: ignore
nmap('<leader>r', '<cmd>update<cr> <cmd>make<cr>', '[R]un file with :make')

-- Delete line but leave an empty line
nmap('X', '"_0D', 'Delete line but leave an empty line')

-- s is for 'search'.
nmap('<leader>/', '<cmd>Pick buf_lines<cr>', '[/] Fuzzily search in current buffer')
nmap('<leader>so', '<cmd>Pick oldfiles<cr>', '[S]earch [O]ld Files')
nmap('<leader>sr', '<cmd>Pick resume<cr>', '[S]earch [R]esume')
nmap('<leader>sf', '<cmd>Pick files<cr>', '[S]earch [F]iles')
nmap('<leader><leader>', '<cmd>Pick files<cr>', '[S]earch [F]iles')
nmap('<leader>sh', '<cmd>Pick help default_split="vertical"<cr>', '[S]earch [H]elp')
nmap('<leader>sb', '<cmd>Pick buffers<cr>', '[S]earch [B]uffers')
nmap('<leader>st', '<cmd>Pick todo<cr>', '[S]earch [T]odo')
nmap('<leader>ss', '<cmd>Pick lsp scope="document_symbol"<cr>', '[S]earch [S]ymbols')
nmap('<leader>sH', '<cmd>Pick history<cr>', '[S]earch [H]istory')
nmap('<leader>sd', '<cmd>Pick diagnostic<cr>', '[S]earch [D]iagnostic')
nmap('<leader>sC', '<cmd>Pick colorschemes<cr>', '[S]earch [C]olorscheme')
nmap('<leader>sg', '<cmd>Pick grep_live<cr>', '[S]earch [G]rep')
nmap('<leader>sw', '<cmd>Pick grep pattern="<cword>"<cr>', '[S]earch [W]ord')
nmap('z=', '<cmd>Pick spellsuggest<cr>', 'Show spellings suggestions')
nmap('<leader>sR', function()
  local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
  require('grug-far').open {
    transient = true,
    prefills = { filesFilter = ext and ext ~= '' and '*.' .. ext or nil },
  }
end, '[S]earch and [R]eplace')

-- g is for 'Git'. Common usage:
-- - `<Leader>gl` - open LazyGit
-- - `<Leader>go` - toggle 'mini.diff' overlay to show in-buffer unstaged changes
nmap('<leader>gL', '<cmd>LazyGit<cr>', 'LazyGit (Project cwd)')
nmap('<leader>gl', '<cmd>LazyGitCurrentFile<cr>', 'LazyGit (current file)')
nmap('<leader>gh', '<cmd>LazyGitFilterCurrentFile<cr>', 'Commit [H]istory (current file)')
nmap('<leader>gH', '<cmd>LazyGitFilter<cr>', 'Commit [H]istory (Project cwd)')
nmap('<leader>gd', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', 'Toggle [d]iff overlay')

-- LSP Stuff
nmap('gd', '<cmd>Pick LspPicker scope="definition"<cr>', 'LSP: [G]oto [D]efinition')
nmap('gr', '<cmd>Pick LspPicker scope="references"<cr>', 'LSP: [G]oto [R]eferences')
nmap('gI', '<cmd>Pick LspPicker scope="implementation"<cr>', 'LSP: [G]oto [I]mplementation')
nmap('gy', '<cmd>Pick LspPicker scope="type_definition"<cr>', 'LSP: [G]oto T[y]pe Definition')
nmap('gD', '<cmd>Pick LspPicker scope="declaration"<cr>', 'LSP: [G]oto [D]eclaration')
nmap('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'LSP: Code [A]ction')
nmap('<leader>cr', '<cmd>lua require("live-rename").rename({insert=true})<cr>', 'LSP: [R]ename')
nmap('h', '<cmd>lua vim.lsp.buf.hover()<cr>', 'LSP: [H]over')
nmap('K', '<nop>', '')

-- Spear
nmap('<leader>la', '<cmd>Spear add<cr>', '[A]dd file to list')
nmap('<leader>ld', '<cmd>Spear remove<cr>', '[D]elete file from list')
nmap('<leader>lD', '<cmd>Spear delete<cr>', '[D]elete list')
nmap('<leader>lc', '<cmd>Spear create<cr>', '[C]reate list')
nmap('<leader>lr', '<cmd>Spear rename<cr>', '[R]ename list')
nmap('<leader>ls', '<cmd>Spear switch<cr>', '[S]witch list')
nmap('<leader>lu', '<cmd>Spear open<cr>', 'Spear UI')
nmap('<A-n>', '<cmd>Spear select 1<cr>')
nmap('<A-e>', '<cmd>Spear select 2<cr>')
nmap('<A-i>', '<cmd>Spear select 3<cr>')
nmap('<A-o>', '<cmd>Spear select 4<cr>')

-- Overseer
nmap('<leader>ow', '<cmd>OverseerToggle<cr>', 'Task list')
nmap('<leader>oo', '<cmd>OverseerRun<cr>', 'Run task')
nmap('<leader>ot', '<cmd>OverseerTaskAction<cr>', 'Task action')
nmap('<leader>os', '<cmd>OverseerShell<cr>', 'Run shell command')

-- Toggles
nmap('<leader>tl', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())

  if vim.diagnostic.is_enabled() then
    vim.notify('Lint enabled', vim.log.levels.INFO)
  else
    vim.notify('Lint disabled', vim.log.levels.INFO)
  end
end, 'Toggle [l]inter')
nmap('<leader>tc', function()
  local context = require 'treesitter-context'

  context.toggle()
  if context.enabled() then
    vim.notify('Context enabled', vim.log.levels.INFO)
  else
    vim.notify('Context disabled', vim.log.levels.INFO)
  end
end, 'Toggle [c]ontext')
vim.g.enable_autoformat = true
nmap('<leader>tf', function()
  vim.g.enable_autoformat = not vim.g.enable_autoformat

  if vim.g.enable_autoformat then
    vim.notify('Autoformatting enabled', vim.log.levels.INFO)
  else
    vim.notify('Autoformatting disabled', vim.log.levels.INFO)
  end
end, 'Toggle auto [f]ormatting')
nmap('<leader>th', function()
  MiniHipatterns.toggle(0)
  vim.g.highlighting_enabled = not vim.g.highlighting_enabled

  if vim.g.highlighting_enabled then
    vim.notify('Highlighting enabled', vim.log.levels.INFO)
  else
    vim.notify('Highlighting disabled', vim.log.levels.INFO)
  end
end, 'Toggle [h]ighlighting')
nmap(
  '<leader>tu',
  '<cmd>lua require("undotree").open({command="leftabove 40vnew"})<cr>',
  'Toggle [u]ndo tree'
)
