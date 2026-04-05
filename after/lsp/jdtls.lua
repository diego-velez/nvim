---@type vim.lsp.Config
return {
  handlers = {
    -- By assigning an empty function, you can remove the notifications
    -- printed to the cmd
    ['$/progress'] = function() end,
  },
}
