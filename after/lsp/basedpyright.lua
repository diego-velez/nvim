---@type vim.lsp.Config
return {
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportUnusedCallResult = 'none',
        },
      },
    },
  },
}
