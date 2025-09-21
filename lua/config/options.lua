-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines/columns to keep around the cursor.
vim.o.scrolloff = 10
vim.o.sidescrolloff = 10

---- DVT's settings ----
vim.o.swapfile = false
vim.o.backup = false

vim.o.colorcolumn = '100'

vim.o.wrap = false

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.termguicolors = true

vim.g.netrw_bufsettings = 'nu rnu'

-- Use indent based folding, and have all folds opened by default
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.o.foldmethod = 'indent'
vim.o.foldenable = false

-- Set rounded borders the default
vim.o.winborder = 'rounded'

vim.o.shell = '/bin/fish'

--
vim.o.splitkeep = 'screen'
vim.o.laststatus = 3

-- Set spell language to English and Spanish
vim.o.spelllang = 'en,es'

-- Show popup even with one item and don't autoselect first
-- Use fuzzy matching for built-in completion
vim.o.completeopt = 'menuone,noselect,fuzzy'
vim.o.complete = '.,w,b,u,t,kspell'
vim.o.shortmess = 'ocFCO'

vim.o.formatoptions = 'croqnljp'
