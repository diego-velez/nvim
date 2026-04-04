-- Kotlin LSP needs JDK 17 or greater
local java_output = vim.system({ 'mise', 'where', 'java@17' }, { text = true }):wait()
local java_home_for_lsp
if java_output.code ~= 0 then
  vim.notify('Could not set up Kotlin LSP', vim.log.levels.ERROR)
else
  -- Output has '\n' at the end, remove that shit here
  java_home_for_lsp = java_output.stdout:gsub('\n', '')
end

---@type vim.lsp.Config
return {
  cmd_env = {
    JAVA_HOME = java_home_for_lsp,
  },
}
