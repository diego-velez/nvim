---@diagnostic disable: missing-fields
---@module "tree-sitter"
---@type TSConfig
require('nvim-treesitter.configs').setup {
  ensure_installed = {
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
  },
  -- Autoinstall languages that are not installed
  auto_install = true,
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    additional_vim_regex_highlighting = { 'ruby' },
  },
  indent = { enable = true, disable = { 'ruby' } },
  textobjects = {
    move = {
      enable = true,
      goto_next_start = {
        [']]'] = '@function.outer',
        [']c'] = '@class.outer',
        -- [N]ote aka comment
        [']n'] = '@comment.outer',
        -- [A]rgument aka parameter
        [']a'] = '@parameter.inner',
      },
      goto_previous_start = {
        ['[['] = '@function.outer',
        ['[c'] = '@class.outer',
        -- [N]ote aka comment
        ['[n'] = '@comment.outer',
        -- [A]rgument aka parameter
        ['[a'] = '@parameter.inner',
      },
    },
  },
}

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
