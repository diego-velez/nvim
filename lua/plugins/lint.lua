local lint = require 'lint'
-- To allow other plugins to add linters to require('lint').linters_by_ft,
-- instead set linters_by_ft like this:
lint.linters_by_ft = lint.linters_by_ft or {}
-- lint.linters_by_ft['markdown'] = { 'markdownlint' }
--
-- However, note that this will enable a set of default linters,
-- which will cause ERRORS unless these tools are available:
-- {
--   clojure = { "clj-kondo" },
--   dockerfile = { "hadolint" },
--   inko = { "inko" },
--   janet = { "janet" },
--   json = { "jsonlint" },
--   markdown = { 'vale' },
--   rst = { "vale" },
--   ruby = { "ruby" },
--   terraform = { "tflint" },
--   text = { "vale" }
-- }
--
-- You can disable the default linters by setting their filetypes to nil:
lint.linters_by_ft['clojure'] = nil
lint.linters_by_ft['dockerfile'] = nil
lint.linters_by_ft['inko'] = nil
lint.linters_by_ft['janet'] = nil
lint.linters_by_ft['json'] = nil
lint.linters_by_ft['markdown'] = nil
lint.linters_by_ft['rst'] = nil
lint.linters_by_ft['ruby'] = nil
lint.linters_by_ft['terraform'] = nil
lint.linters_by_ft['text'] = nil

-- Create autocommand which carries out the actual linting
-- on the specified events.
-- Allows toggling the linter on or off
vim.g.lint_enabled = true
local toggle_lint = function()
  vim.g.lint_enabled = not vim.g.lint_enabled
  if vim.g.lint_enabled then
    vim.diagnostic.show(nil, 0)
    vim.notify('Lint enabled', vim.log.levels.INFO)
  else
    vim.diagnostic.hide(nil, 0)
    vim.notify('Lint disabled', vim.log.levels.INFO)
  end
end

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    -- Only run the linter when it is enabled, and in buffers that you
    -- can modify in order to avoid superfluous noise, notably within
    -- the handy LSP pop-ups that describe the hovered symbol using Markdown.
    if vim.g.lint_enabled and vim.bo.modifiable then
      lint.try_lint()
    end
  end,
})

vim.keymap.set('n', '<leader>tl', toggle_lint, { desc = 'Toggle [L]inter' })
