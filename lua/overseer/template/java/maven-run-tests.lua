---@module "overseer"
---@type overseer.TemplateDefinition
return {
  name = 'Maven Test',
  builder = function(_)
    local files = vim.fs.find(
      { 'mvnw' },
      { upward = true, limit = math.huge, type = 'file', path = vim.fn.expand '%:p' }
    )
    local cwd = vim.fs.dirname(files[1]) or vim.uv.cwd()
    local rel_cwd = vim.fs.basename(cwd)
    ---@type overseer.TaskDefinition
    return {
      cmd = './mvnw',
      args = { 'test' },
      name = string.format('Maven Test in %s', rel_cwd),
      cwd = cwd,
    }
  end,
  tags = { require('overseer.constants').TAG.TEST },
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
