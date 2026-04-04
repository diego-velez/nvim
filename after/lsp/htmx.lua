---@type vim.lsp.Config
return {
  cmd = { 'htmx-lsp', '--level', 'OFF' },
  settings = {
    filetypes = {
      'gohtml',
      'gohtmltmpl',
      'handlebars',
      'html',
      'mustache',
      -- 'templ',
    },
  },
}
