return {
  name = 'Upload Service (Skaffold)',
  builder = function(_)
    local files = vim.fs.find(
      { 'skaffold.yaml' },
      { upward = true, limit = math.huge, type = 'file', path = vim.fn.expand '%:p' }
    )
    local cwd = vim.fs.dirname(files[1]) or vim.uv.cwd()
    local rel_cwd = vim.fs.basename(cwd)
    ---@type overseer.TaskDefinition
    return {
      cmd = 'skaffold',
      args = {
        'run',
        '--profile',
        'dev',
        '--kube-context=gke_diveto-louhi-test_us-central1_louhi',
        '--skip-tests',
        '--default-repo="us-central1-docker.pkg.dev/diveto-louhi-test/microservices"',
      },
      name = string.format('Upload %s', rel_cwd),
      cwd = cwd,
    }
  end,
  tags = { require('overseer.constants').TAG.BUILD },
  module = 'skaffold',
  condition = {
    callback = function(search)
      local files = vim.fs.find(
        { 'skaffold.yaml' },
        { upward = true, limit = math.huge, type = 'file', path = search.dir }
      )
      return #files > 0
    end,
  },
}
