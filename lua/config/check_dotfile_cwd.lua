-- Setup git variables if working on a directory tracked by my dotfiles repo
local home = vim.fn.getenv 'HOME'
local git_dir = home .. '/.files'
local work_tree = home
local dotfiles_files = vim
  .system({
    'git',
    '--git-dir=' .. git_dir,
    '--work-tree=' .. work_tree,
    'ls-files',
    '--full-name',
    home,
  }, { text = true })
  :wait()
local cwd = vim.fn.getcwd()
cwd = string.sub(cwd, #home + 2)
if cwd ~= nil and string.find(dotfiles_files.stdout, cwd, 1, true) ~= nil then
  vim.env.GIT_WORK_TREE = home
  vim.env.GIT_DIR = git_dir
end

vim.api.nvim_create_user_command(
  'ToggleConfig',
  ---@param _ vim.api.keyset.create_user_command.command_args
  function(_)
    local config_on = vim.env.GIT_WORK_TREE ~= nil and vim.env.GIT_DIR ~= nil
    if config_on then
      vim.env.GIT_WORK_TREE = nil
      vim.env.GIT_DIR = nil
    else
      vim.env.GIT_WORK_TREE = home
      vim.env.GIT_DIR = git_dir
    end
  end,
  {
    nargs = 0,
  }
)
