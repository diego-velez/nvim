-- Auto-install treesitter parsers
require('nvim-treesitter').install {
  'bash',
  'c',
  'diff',
  'go',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'jsonc',
  'lua',
  'luadoc',
  'luap',
  'markdown',
  'markdown_inline',
  'printf',
  'python',
  'query',
  'regex',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
}

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
