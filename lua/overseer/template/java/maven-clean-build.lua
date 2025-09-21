---@module "overseer"
---@type overseer.TemplateDefinition
return {
  name = 'Maven Clean and Build',
  builder = function(_)
    local files = vim.fs.find(
      { 'mvnw' },
      { upward = true, limit = math.huge, type = 'file', path = vim.fn.expand '%:p' }
    )
    local cwd = vim.fs.dirname(files[1]) or vim.uv.cwd()
    local rel_cwd = vim.fs.basename(cwd)
    ---@type overseer.TaskDefinition
    return {
      cmd = '',
      name = string.format('Maven Clean and Build for %s', rel_cwd),
      cwd = cwd,
      strategy = {
        'orchestrator',
        tasks = {
          'Maven Clean',
          'Maven Build',
        },
      },
    }
  end,
  tags = {
    require('overseer.constants').TAG.CLEAN,
    require('overseer.constants').TAG.BUILD,
  },
  module = 'java',
  condition = {
    callback = function(search)
      local files = vim.fs.find(
        { 'mvnw' },
        { upward = true, limit = math.huge, type = 'file', path = search.dir }
      )
      return #files > 0
    end,
  },
}
