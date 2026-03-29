-- Auto-install treesitter parsers
-- Define languages which will have parsers installed and auto enabled
-- After changing this, restart Neovim once to install necessary parsers. Wait
-- for the installation to finish before opening a file for added language(s).
local languages = {
  'bash',
  'c',
  'diff',
  'go',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'lua',
  'luadoc',
  'luap',
  'markdown',
  'markdown_inline',
  'printf',
  'python',
  'query',
  'regex',
  'templ',
  'toml',
  'tsx',
  'typescript',
  'typst',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
  -- To see available languages:
  -- - Execute `:=require('nvim-treesitter').get_available()`
  -- - Visit 'SUPPORTED_LANGUAGES.md' file at
  --   https://github.com/nvim-treesitter/nvim-treesitter/blob/main
}
local isnt_installed = function(lang)
  return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
end
local to_install = vim.tbl_filter(isnt_installed, languages)
if #to_install > 0 then
  require('nvim-treesitter').install(to_install)
end

-- Enable treesitter after opening a file for a target language
local filetypes = {}
for _, lang in ipairs(languages) do
  for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
    table.insert(filetypes, ft)
  end
end
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('Start treesitter', { clear = true }),
  pattern = filetypes,
  callback = function(ev)
    vim.treesitter.start(ev.buf)
  end,
})

-- Setup treesitter textobjects

local move = require 'nvim-treesitter-textobjects.move'
local goto_previous_start = function(keymap, textobject, description)
  vim.keymap.set({ 'n', 'x', 'o' }, keymap, function()
    move.goto_previous_start(textobject, 'textobjects')
  end, { desc = description })
end
local goto_next_start = function(keymap, textobject, description)
  vim.keymap.set({ 'n', 'x', 'o' }, keymap, function()
    move.goto_next_start(textobject, 'textobjects')
  end, { desc = description })
end

goto_previous_start('[[', '@function.outer', 'Go to previous function')
goto_previous_start('[c', '@class.outer', 'Go to previous [c]lass')
goto_previous_start('[n', '@comment.outer', 'Go to previous comment/[n]ote')
goto_previous_start('[a', '@parameter.inner', 'Go to previous [a]rgument')

goto_next_start(']]', '@function.outer', 'Go to next function')
goto_next_start(']c', '@class.outer', 'Go to next [c]lass')
goto_next_start(']n', '@comment.outer', 'Go to next comment/[n]ote')
goto_next_start(']a', '@parameter.inner', 'Go to next [a]rgument')

-- Setup treesitter context
local context = require 'treesitter-context'
context.setup {
  max_lines = 1,
  multiline_threshold = 1,
}

vim.keymap.set('n', '<leader>tc', function()
  context.toggle()
  if context.enabled() then
    vim.notify('Context enabled', vim.log.levels.INFO)
  else
    vim.notify('Context disabled', vim.log.levels.INFO)
  end
end, { desc = 'Toggle [c]ontext' })

require('ts-comments').setup()
