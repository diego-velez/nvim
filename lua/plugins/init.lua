local add, now, later = vim.pack.add, Config.now, Config.later
local now_if_args = Config.now_if_args

-- mini
now(function()
  add {
    'https://github.com/Mofiqul/dracula.nvim.git',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    'https://github.com/folke/ts-comments.nvim',
  }

  add { 'https://github.com/p00f/alabaster.nvim' }

  require 'plugins.mini'
  require 'plugins.colorschemes'

  vim.cmd.colorscheme 'dracula'
end)

-- Treesitter
now_if_args(function()
  local plugin_name = 'nvim-treesitter'

  -- Define hook to update tree-sitter parsers after plugin is updated
  vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('Update treesitter', {}),
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind
      if name ~= plugin_name and kind ~= 'update' then
        return
      end

      if not ev.data.active then
        vim.cmd.packadd(plugin_name)
      end

      vim.cmd.TSUpdate()
    end,
    desc = ':TSUpdate',
  })

  add {
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    'https://github.com/nvim-treesitter/nvim-treesitter-context',
    'https://github.com/folke/ts-comments.nvim',
  }

  require 'plugins.treesitter'
end)

-- LSP
now_if_args(function()
  add {
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/DrKJeff16/wezterm-types',
    'https://github.com/saecki/live-rename.nvim',
  }

  add {
    {
      src = 'https://github.com/JavaHello/spring-boot.nvim',
      version = '218c0c26c14d99feca778e4d13f5ec3e8b1b60f0',
    },
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/mfussenegger/nvim-dap',

    'https://github.com/nvim-java/nvim-java',
  }

  require('java').setup()
  vim.lsp.enable 'jdtls'

  require 'plugins.lsp_config'
end)

-- Formatter
later(function()
  add { 'https://github.com/stevearc/conform.nvim' }

  require 'plugins.conform'
end)

-- Linter
now_if_args(function()
  add { 'https://github.com/mfussenegger/nvim-lint' }

  require 'plugins.lint'
end)

-- Git integration
later(function()
  add {
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/kdheepak/lazygit.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
  }

  require 'plugins.git'
end)

-- Autopair stuff
later(function()
  add { 'https://github.com/windwp/nvim-autopairs', 'https://github.com/windwp/nvim-ts-autotag' }

  require('nvim-autopairs').setup()
  require('nvim-ts-autotag').setup()

  local npairs = require 'nvim-autopairs'
  local Rule = require 'nvim-autopairs.rule'
  local cond = require 'nvim-autopairs.conds'
  local ts_cond = require 'nvim-autopairs.ts-conds'

  -- Autopair rules for Typst
  npairs.add_rules {
    Rule('$', '$', 'typst')
      :with_pair(cond.not_after_text '$')
      :with_pair(cond.not_before_text '\\')
      :with_pair(ts_cond.is_not_ts_node 'string')
      :with_move(cond.after_text '$'),
    Rule('*', '*', 'typst')
      :with_pair(cond.not_after_text '*')
      :with_pair(cond.not_before_text '\\')
      :with_pair(ts_cond.is_not_ts_node 'math')
      :with_pair(ts_cond.is_not_ts_node 'string')
      :with_move(cond.after_text '*'),
    Rule('_', '_', 'typst')
      :with_pair(cond.not_after_text '_')
      :with_pair(cond.not_before_text '\\')
      :with_pair(ts_cond.is_not_ts_node 'math')
      :with_pair(ts_cond.is_not_ts_node 'string')
      :with_move(cond.after_text '_'),
  }
end)

-- Support TODO comments
later(function()
  add {
    'https://github.com/folke/todo-comments.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
  }

  require 'plugins.todo'
end)

-- Configure windows
later(function()
  add { 'https://github.com/folke/edgy.nvim' }

  require 'plugins.edgy'
end)

-- Search and replace
later(function()
  add { 'https://github.com/MagicDuck/grug-far.nvim' }

  require 'plugins.grug-far'
end)

-- Typescript stuff
later(function()
  add {
    'https://github.com/pmizio/typescript-tools.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/dmmulroy/ts-error-translator.nvim',
  }

  require('typescript-tools').setup {}
  require('ts-error-translator').setup()
end)

-- Support markdown
later(function()
  add {
    'https://github.com/MeanderingProgrammer/render-markdown.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-mini/mini.nvim',
  }

  require('render-markdown').setup()
end)

-- Task runner
later(function()
  add {
    {
      src = 'https://github.com/diego-velez/overseer.nvim',
      version = 'task_output_filetype',
    },
  }

  require 'plugins.overseer'
end)

-- My spear
later(function()
  add {
    'https://github.com/diego-velez/spear.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
  }

  require 'plugins.spear'
end)

-- Undo tree
later(function()
  add { 'https://github.com/mbbill/undotree' }

  vim.g.undotree_WindowLayout = 2
  vim.g.undotree_SetFocusWhenToggle = 1

  vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle, { desc = 'Toggle [u]ndo tree' })
end)

-- Automatically set indentation
later(function()
  add { 'https://github.com/NMAC427/guess-indent.nvim' }

  require('guess-indent').setup()
end)

-- Cool cursor animations
later(function()
  add { 'https://github.com/sphamba/smear-cursor.nvim' }

  require('smear_cursor').setup()
end)

-- HTTP request support
later(function()
  add { 'https://github.com/mistweaverco/kulala.nvim' }

  local kulala = require 'kulala'
  kulala.setup()

  -- stylua: ignore
  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Kulala specific keymaps',
    group = vim.api.nvim_create_augroup('DVT Kulala', { clear = true }),
    pattern = { 'http', 'rest' },
    callback = function(args)
      vim.keymap.set('n', '<leader>r', '', { buffer = args.buf, desc = '[R]un' })
      vim.keymap.set('n', '<leader>rs', kulala.run, { buffer = args.buf, desc = '[S]end request' })
      vim.keymap.set('n', '<leader>ra', kulala.run_all, { buffer = args.buf, desc = 'Send [A]ll requests' })
      vim.keymap.set('n', '<leader>rp', kulala.replay, { buffer = args.buf, desc = 'Run [P]revious' })
      vim.keymap.set('n', '<leader>ru', kulala.toggle_view, { buffer = args.buf, desc = 'Toggle UI' })
      vim.keymap.set('n', '{', kulala.jump_prev, { buffer = args.buf, desc = 'Previous Request' })
      vim.keymap.set('n', '}', kulala.jump_next, { buffer = args.buf, desc = 'Next Request' })
    end,
  })
end)

-- Images in the terminal
later(function()
  add { 'https://github.com/3rd/image.nvim' }

  local image = require 'image'
  image.setup()
  image.disable() -- Disable images by default

  vim.keymap.set('n', '<leader>tI', function()
    if image.is_enabled() then
      image.disable()
      vim.notify('Images disabled', vim.log.levels.INFO)
    else
      image.enable()
      vim.notify('Images enabled', vim.log.levels.INFO)
    end
  end, { desc = 'Toggle [I]mages' })
end)
