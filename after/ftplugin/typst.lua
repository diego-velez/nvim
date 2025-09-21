vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

vim.keymap.set(
  'n',
  '<leader>r',
  vim.cmd.TypstPreview,
  { buffer = 0, desc = '[R]un Preview in Browser' }
)
