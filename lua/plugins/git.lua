---@diagnostic disable: param-type-mismatch
local gitsigns = require 'gitsigns'
gitsigns.setup {
  current_line_blame_opts = {
    delay = 0,
  },
  preview_config = {
    border = 'rounded',
  },
  on_attach = function(bufnr)
    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    -- Hunk Navigation
    map('n', '[G', function()
      gitsigns.nav_hunk 'first'
    end, 'Previous [G]it Change')
    map('n', '[g', function()
      gitsigns.nav_hunk 'prev'
    end, 'Previous [G]it Change')

    map('n', ']g', function()
      gitsigns.nav_hunk 'next'
    end, 'Next [G]it Change')
    map('n', ']G', function()
      gitsigns.nav_hunk 'last'
    end, 'Next [G]it Change')

    -- Hunk Actions
    map('n', '<leader>gs', gitsigns.stage_hunk, 'Toggle [S]tage hunk')
    map('v', '<leader>gs', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, '[S]tage hunk')
    map('n', '<leader>gr', gitsigns.reset_hunk, '[R]eset hunk')
    map('v', '<leader>gr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, '[R]eset hunk')
    map('n', '<leader>gp', gitsigns.preview_hunk, '[P]review hunk')

    -- Buffer Actions
    map('n', '<leader>gS', gitsigns.stage_buffer, '[S]tage buffer')
    map('n', '<leader>gR', gitsigns.reset_buffer, '[R]eset buffer')

    -- Diffing
    map('n', '<leader>gd', gitsigns.diffthis, '[D]iff against head')
    map('n', '<leader>gD', function()
      gitsigns.diffthis '~'
    end, '[D]iff against previous commit')

    -- Blame
    map('n', '<leader>gb', gitsigns.toggle_current_line_blame, 'Toggle [b]lame')
    map('n', '<leader>gB', function()
      gitsigns.blame_line { full = true }
    end, 'Show [b]lame')

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Git [h]unk')
  end,
}

-- Keymaps

vim.keymap.set('n', '<leader>gL', '<cmd>LazyGit<cr>', { desc = 'LazyGit (Project cwd)' })
vim.keymap.set(
  'n',
  '<leader>gl',
  '<cmd>LazyGitCurrentFile<cr>',
  { desc = 'LazyGit (current file)' }
)
vim.keymap.set(
  'n',
  '<leader>gh',
  '<cmd>LazyGitFilterCurrentFile<cr>',
  { desc = 'Commit [H]istory (current file)' }
)
vim.keymap.set(
  'n',
  '<leader>gH',
  '<cmd>LazyGitFilter<cr>',
  { desc = 'Commit [H]istory (Project cwd)' }
)
