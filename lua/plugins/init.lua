local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

---@param args { path: string, name: string, source: string }
local function build_with_rust(args)
  local cmd = { 'rustup', 'run', 'nightly', 'cargo', 'build', '--release' }
  ---@type vim.SystemOpts
  local opts = { cwd = args.path, text = true }

  vim.notify('Building ' .. args.name, vim.log.levels.INFO)
  local output = vim.system(cmd, opts):wait()
  if output.code ~= 0 then
    vim.notify('Failed to build ' .. args.name .. '\n' .. output.stderr, vim.log.levels.ERROR)
  else
    vim.notify('Built ' .. args.name, vim.log.levels.INFO)
  end
end

-- Other Neovim config stuff
later(function()
  require 'config.other'
  require 'config.check_dotfile_cwd'
end)

-- mini
now(function()
  add {
    source = 'diego-velez/fff.nvim',
    hooks = {
      post_install = build_with_rust,
      post_checkout = build_with_rust,
    },
  }

  add {
    name = 'mini.nvim',
    depends = {
      'Mofiqul/dracula.nvim.git',
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'dmtrKovalenko/fff.nvim',
    },
  }

  require 'plugins.colorschemes'
  vim.cmd.colorscheme 'dracula'
end)

now_if_args(function()
  add {
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = {
      post_checkout = function()
        vim.cmd.TSUpdate()
      end,
    },
  }
  add 'nvim-treesitter/nvim-treesitter-context'
  add 'folke/ts-comments.nvim'

  require 'plugins.treesitter'
end)

now(function()
  require 'plugins.mini'
end)

-- LSP
later(function()
  add {
    source = 'neovim/nvim-lspconfig',
    depends = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'folke/lazydev.nvim',
      'justinsgithub/wezterm-types',
      'saecki/live-rename.nvim',
      'andrewferrier/debugprint.nvim',
    },
  }

  add {
    source = 'nvim-java/nvim-java',
    depends = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-refactor',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'mfussenegger/nvim-dap',
      'JavaHello/spring-boot.nvim',
    },
  }

  require 'plugins.lsp_config'
end)

-- Formatter
later(function()
  add 'stevearc/conform.nvim'

  require 'plugins.conform'
end)

-- Linter
later(function()
  add 'mfussenegger/nvim-lint'

  require 'plugins.lint'
end)

-- Git integration
later(function()
  add 'lewis6991/gitsigns.nvim'

  add {
    source = 'kdheepak/lazygit.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
  }

  require 'plugins.git'
end)

-- Autopair stuff
later(function()
  add 'windwp/nvim-autopairs'
  add 'windwp/nvim-ts-autotag'

  require('nvim-autopairs').setup()
  require('nvim-ts-autotag').setup()
end)

-- Support TODO comments
later(function()
  add {
    source = 'folke/todo-comments.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
  }

  require 'plugins.todo'
end)

-- Configure windows
later(function()
  add 'folke/edgy.nvim'

  require 'plugins.edgy'
end)

-- Terminal support
later(function()
  add {
    source = 'nvzone/floaterm',
    depends = { 'nvzone/volt' },
  }

  require 'plugins.terminal'
end)

-- Search and replace
later(function()
  add 'MagicDuck/grug-far.nvim'

  require 'plugins.grug-far'
end)

-- Typescript stuff
later(function()
  add {
    source = 'pmizio/typescript-tools.nvim',
    depends = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  }

  add 'dmmulroy/ts-error-translator.nvim'

  require('typescript-tools').setup {}
  require('ts-error-translator').setup()
end)

-- Support markdown
later(function()
  add {
    source = 'MeanderingProgrammer/render-markdown.nvim',
    depends = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
  }

  require('render-markdown').setup()
end)

-- Better LISP like language support
later(function()
  add {
    source = 'eraserhd/parinfer-rust',
    hooks = {
      post_install = build_with_rust,
      post_checkout = build_with_rust,
    },
  }
end)

-- Task runner
later(function()
  add {
    source = 'diego-velez/overseer.nvim',
    checkout = 'task_output_filetype',
  }

  require 'plugins.overseer'
end)

-- My spear
later(function()
  add {
    source = 'diego-velez/spear.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
  }

  require 'plugins.spear'
end)

-- Undo tree
later(function()
  add 'mbbill/undotree'

  vim.g.undotree_WindowLayout = 2
  vim.g.undotree_SetFocusWhenToggle = 1

  vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle, { desc = 'Toggle [u]ndo tree' })
end)

-- Better yanking
later(function()
  add 'gbprod/yanky.nvim'

  require 'plugins.yanky'
end)

-- Automatically set indentation
later(function()
  add 'NMAC427/guess-indent.nvim'

  require('guess-indent').setup()
end)

-- Write files as root
later(function()
  add 'lambdalisue/vim-suda'
end)

-- Cool cursor animations
later(function()
  add 'sphamba/smear-cursor.nvim'

  require('smear_cursor').setup()
end)

-- Typst preview
later(function()
  add {
    source = 'chomosuke/typst-preview.nvim',
    checkout = 'v1.3.2',
  }

  require('typst-preview').setup {}

  local npairs = require 'nvim-autopairs'
  local Rule = require 'nvim-autopairs.rule'
  local cond = require 'nvim-autopairs.conds'

  -- `$$` as autopair for Typst
  npairs.add_rules {
    Rule('$', '$', 'typst'):with_pair(cond.not_after_text '$'):with_move(cond.after_text '$'),
    Rule('*', '*', 'typst'):with_pair(cond.not_after_text '*'):with_move(cond.after_text '*'),
  }
end)

-- HTTP request support
later(function()
  add 'mistweaverco/kulala.nvim'

  -- stylua: ignore
  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Kulala specific keymaps',
    group = vim.api.nvim_create_augroup('DVT Kulala', { clear = true }),
    pattern = { 'http', 'rest' },
    callback = function(args)
      local kulala = require 'kulala'
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

-- Focus mode
later(function()
  add 'shortcuts/no-neck-pain.nvim'

  require 'plugins.no-neck-pain'
end)
