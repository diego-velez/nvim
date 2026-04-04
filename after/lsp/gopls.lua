---@type vim.lsp.Config
return {
  filetypes = {
    'go',
    'templ',
  },
  settings = {
    gopls = {
      templateExtensions = {
        'templ',
      },
      ['ui.inlayhint.hints'] = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
