---@module "overseer"
---@type overseer.TemplateFileDefinition
return {
  name = 'MkDocs Serve',
  builder = function(_)
    local files = vim.fs.find(
      { 'mkdocs.yml' },
      { upward = true, limit = math.huge, type = 'file', path = vim.fn.expand '%:p' }
    )
    local cwd = vim.fs.dirname(files[1]) or vim.uv.cwd()
    local rel_cwd = vim.fs.basename(cwd)
    ---@type overseer.TaskDefinition
    return {
      cmd = 'mkdocs serve',
      name = string.format('MkDocs Serve %s', rel_cwd),
      cwd = cwd,
    }
  end,
  tags = { require('overseer.constants').TAG.RUN },
  module = 'mkdocs',
}
