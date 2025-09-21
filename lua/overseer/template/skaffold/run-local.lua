return {
  name = 'Run Frontend (Real)',
  builder = function(_)
    local files = vim.fs.find(
      { 'skaffold-local.yaml' },
      { upward = true, limit = math.huge, type = 'file', path = vim.fn.expand '%:p' }
    )
    local cwd = vim.fs.dirname(files[1]) or vim.uv.cwd()
    ---@type overseer.TaskDefinition
    return {
      cmd = 'skaffold run --profile local --filename skaffold-local.yaml && gcloud container clusters get-credentials louhi --region us-central1 --project diveto-louhi-test && kubectl port-forward --namespace louhi $(kubectl get pod --namespace louhi --selector="app=api-personal-gateway-service" --output jsonpath=\'{.items[0].metadata.name}\') 8080:8080',
      name = 'Run Frontend (Real)',
      cwd = cwd,
    }
  end,
  tags = { require('overseer.constants').TAG.RUN },
  module = 'skaffold',
  condition = {
    dir = 'ui/frontend',
  },
}
