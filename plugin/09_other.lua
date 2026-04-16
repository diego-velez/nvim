local add, now, later = vim.pack.add, Config.now, Config.later
local now_if_args = Config.now_if_args
local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

-- Enable experimental v2 UI system
now(function()
  require('vim._core.ui2').enable {
    enable = true,
    msg = {
      targets = {
        [''] = 'msg',
        empty = 'cmd',
        bufwrite = 'msg',
        confirm = 'cmd',
        emsg = 'pager',
        echo = 'msg',
        echomsg = 'msg',
        echoerr = 'pager',
        completion = 'cmd',
        list_cmd = 'pager',
        lua_error = 'pager',
        lua_print = 'msg',
        progress = 'pager',
        rpc_error = 'pager',
        quickfix = 'msg',
        search_cmd = 'cmd',
        search_count = 'cmd',
        shell_cmd = 'pager',
        shell_err = 'pager',
        shell_out = 'pager',
        shell_ret = 'msg',
        undo = 'msg',
        verbose = 'pager',
        wildlist = 'cmd',
        wmsg = 'msg',
        typed_cmd = 'cmd',
      },
      cmd = {
        height = 0.5,
      },
      dialog = {
        height = 0.5,
      },
      msg = {
        height = 0.3,
        timeout = 5000,
      },
      pager = {
        height = 0.5,
      },
    },
  }
end)

-- Dracula colorscheme
now(function()
  add { 'https://github.com/Mofiqul/dracula.nvim.git' }

  require('dracula').setup {
    italic_comment = true,
    overrides = function(colors)
      return {
        -- Setup mini.statusline
        MiniStatuslineInactive = { fg = colors.white, bg = colors.menu, bold = true },

        -- Setup mini.pick
        MiniFilesBorder = { fg = colors.purple, bg = colors.menu },
        MiniFilesBorderModified = { fg = colors.yellow, bg = colors.menu },
        MiniFilesCursorLine = { fg = colors.white, bg = colors.bg },
        MiniFilesNormal = { fg = 'fg', bg = colors.menu },
        MiniFilesTitle = { fg = colors.white, bg = colors.menu },
        MiniFilesTitleFocused = { fg = 'fg', bg = colors.menu },

        -- Setup mini.starter
        MiniStarterCurrent = { fg = colors.fg, bg = 'bg' },
        MiniStarterHeader = { fg = colors.green, bg = 'bg' },
        MiniStarterFooter = { fg = colors.green, bg = 'bg' },
        MiniStarterItem = { fg = colors.white, bg = 'bg' },
        MiniStarterItemBullet = { fg = colors.cyan, bg = 'bg' },
        MiniStarterSection = { fg = colors.cyan, bg = 'bg' },

        -- Setup mini.pick
        MiniPickBorder = { fg = colors.purple, bg = colors.menu },
        MiniPickBorderText = { fg = colors.white, bg = colors.menu },
        MiniPickPrompt = { fg = colors.purple, bg = colors.menu },
        MiniPickMatchCurrent = { fg = colors.white, bg = colors.bg },
        MiniPickMatchRanges = { fg = colors.green, bg = colors.menu },
        MiniPickNormal = { fg = 'fg', bg = colors.menu },

        -- Setup mini.clue
        MiniClueBorder = { fg = colors.purple, bg = colors.menu },
        MiniClueDescGroup = { fg = colors.green, bg = colors.menu },
        MiniClueDescSingle = { fg = 'fg', bg = colors.menu },
        MiniClueNextKey = { fg = colors.cyan, bg = colors.menu },
        MiniClueNextKeyWithPostkeys = { fg = colors.cyan, bg = colors.menu },
        MiniClueSeparator = { fg = colors.cyan, bg = colors.menu },
        MiniClueTitle = { fg = colors.white, bg = colors.menu },

        -- Setup mini.notify
        MiniNotifyNormal = { fg = 'fg', bg = colors.menu },
        MiniNotifyBorder = { fg = colors.purple, bg = colors.menu },
        MiniNotifyTitle = { fg = colors.white, bg = colors.menu },

        -- Setup mini.trailspace
        MiniTrailspace = { bg = colors.bright_red },

        -- Setup mini.jump
        MiniJump = { fg = colors.orange, bg = colors.bg, underline = true },

        -- Setup harpoon window highlight groups
        HarpoonNormal = { fg = colors.fg, bg = colors.menu },
        HarpoonBorder = { fg = colors.purple, bg = colors.menu },
        HarpoonTitle = { fg = colors.white, bg = colors.menu },

        -- Setup gitconflict
        GitConflictIncomingLabel = {
          fg = colors.bg,
          bg = colors.bright_green,
          bold = true,
          italic = true,
        },
        GitConflictIncoming = { fg = colors.green },
        GitConflictCurrent = { fg = colors.red },
        GitConflictCurrentLabel = {
          fg = colors.bg,
          bg = colors.bright_red,
          bold = true,
          italic = true,
        },

        -- Setup treesitter context
        TreesitterContextBottom = { bg = colors.menu },

        -- Setup on yank highlight
        TextYank = { link = 'Search' },
      }
    end,
  }

  vim.cmd.colorscheme 'dracula'
  -- Change the color of the division block by using its highlight group
  vim.api.nvim_set_hl(0, 'Statusline', { bg = 'bg' })
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

  -- Auto-install treesitter parsers
  -- Defined languages which will have parsers installed and auto enabled
  -- After changing this, restart Neovim once to install necessary parsers. Wait
  -- for the installation to finish before opening a file for added language(s).
  -- stylua: ignore start
  local languages = {
    'bash', 'c', 'diff', 'go', 'html', 'javascript', 'jsdoc', 'json', 'lua', 'luadoc', 'luap',
    'markdown', 'markdown_inline', 'printf', 'python', 'query', 'regex', 'templ', 'toml', 'tsx',
    'typescript', 'typst', 'vim', 'vimdoc', 'xml', 'yaml', 'yaml.ghaction',
  }
  -- stylua: ignore end

  later(function()
    local isnt_installed = function(lang)
      return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
    end
    local to_install = vim.tbl_filter(isnt_installed, languages)
    if #to_install > 0 then
      require('nvim-treesitter').install(to_install)
    end
  end)

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
  require('treesitter-context').setup {
    max_lines = 1,
    multiline_threshold = 1,
  }

  require('ts-comments').setup()
end)

-- LSP
now_if_args(function()
  vim.lsp.log.set_level(vim.log.levels.OFF)

  require('mini.misc').safely('filetype:java', function()
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
  end)

  require('mini.misc').safely('filetype:nix', function()
    vim.lsp.enable 'nixd'
  end)

  add {
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/DrKJeff16/wezterm-types',
    'https://github.com/saecki/live-rename.nvim',
  }

  require('lazydev').setup {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      { path = 'wezterm-types', mods = { 'wezterm' } },
      { path = '$HOME/.local/share/LuaAddons/', words = { 'love.' } },
    },
  }

  -- Make sure all LSPs and mason tools are installed
  local ensure_installed = {
    'actionlint',
    'templ',
    'gopls',
    'basedpyright',
    'lua_ls',
    -- WARN: You need to have `openssl-devel` to install asm_lsp
    'asm_lsp',
    'clangd',
    'tinymist',
    'kotlin_lsp',
    'qmlls',
    'ruff',
    'stylua', -- Used to format Lua code
    'bash-language-server',
    'html-lsp',
    'css-lsp',
    'json-lsp',
    'jq',
  }

  later(function()
    add {
      'https://github.com/mason-org/mason.nvim',
      'https://github.com/mason-org/mason-lspconfig.nvim',
      'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    }

    require('mason').setup {}
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    vim.cmd.MasonToolsInstall()

    -- Enable LSP servers
    require('mason-lspconfig').setup { automatic_enable = true }
  end)
end)

-- Formatter
now_if_args(function()
  add { 'https://github.com/stevearc/conform.nvim' }

  local disable_filetypes = { c = true, cpp = true }
  local disable_lsp_formatter = { java = true }

  require('conform').setup {
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Do not autoformat if it is disabled
      if not vim.g.enable_autoformat then
        return
      end

      local buf_filetype = vim.bo[bufnr].filetype

      if disable_filetypes[buf_filetype] then
        return nil
      elseif disable_lsp_formatter[buf_filetype] then
        return {
          timeout_ms = 500,
          lsp_format = 'never',
        }
      end

      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end,
    formatters = {
      hclfmt = {
        command = '/google/data/ro/teams/terraform/bin/hclfmt',
      },
    },
    ---@module "conform"
    ---@type conform.FiletypeFormatter[]
    formatters_by_ft = {
      lua = { 'stylua' },
      templ = { 'templ' },
      html = { 'prettier' },
      markdown = { 'prettier' },
      typescriptreact = { 'prettier' },
      typescript = { 'prettier' },
      javascript = { 'prettier' },
      sql = { 'pg_format' },
      java = { 'google-java-format', lsp_format = 'never' },
      terraform = { 'hclfmt' },
      json = { 'jq' },
      jsonc = { 'biome' },
      nix = { 'nixfmt' },
    },
  }

  vim.keymap.set('n', '<leader>f', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local buf_filetype = vim.bo[bufnr].filetype

    local lsp_format = 'fallback'
    if disable_lsp_formatter[buf_filetype] then
      lsp_format = 'never'
    end

    require('conform').format { async = true, lsp_format = lsp_format }
  end, { desc = '[F]ormat buffer' })
end)

-- Linter
now_if_args(function()
  add { 'https://github.com/mfussenegger/nvim-lint' }

  vim.filetype.add { pattern = { ['.*/.github/workflows/.*%.yml'] = 'yaml.ghaction' } }
  require('lint').linters_by_ft = {
    ['yaml.ghaction'] = { 'actionlint' },
    go = { 'golangcilint' },
    bash = { 'bash' },
    fish = { 'fish' },
  }

  -- Create autocommand which carries out the actual linting on the specified events.
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    desc = 'Run linting for current modifiable buffer',
    group = vim.api.nvim_create_augroup('lint', { clear = true }),
    callback = function()
      -- Only run the linter in buffers that you
      -- can modify in order to avoid superfluous noise, notably within
      -- the handy LSP pop-ups that describe the hovered symbol using Markdown.
      if vim.bo.modifiable then
        require('lint').try_lint()
      end
    end,
  })
end)

-- Git integration
later(function()
  add {
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/kdheepak/lazygit.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
  }

  ---@diagnostic disable: param-type-mismatch
  local gitsigns = require 'gitsigns'
  gitsigns.setup {
    current_line_blame_opts = {
      delay = 0,
    },
    preview_config = {
      border = 'rounded',
    },
    numhl = true,
    on_attach = function(bufnr)
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Hunk Navigation
      map('n', '[G', function()
        gitsigns.nav_hunk 'first'
      end, 'Previous [G]it Change')
      map('n', '[g', function()
        gitsigns.nav_hunk 'prev'
      end, 'Previous [G]it Change')

      map('n', ']g', function()
        gitsigns.nav_hunk 'next'
      end, 'Next [G]it Change')
      map('n', ']G', function()
        gitsigns.nav_hunk 'last'
      end, 'Next [G]it Change')

      -- Hunk Actions
      map('n', '<leader>gs', gitsigns.stage_hunk, 'Toggle [S]tage hunk')
      map('v', '<leader>gs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, '[S]tage hunk')
      map('n', '<leader>gr', gitsigns.reset_hunk, '[R]eset hunk')
      map('v', '<leader>gr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, '[R]eset hunk')
      map('n', '<leader>gp', gitsigns.preview_hunk, '[P]review hunk')

      -- Buffer Actions
      map('n', '<leader>gS', gitsigns.stage_buffer, '[S]tage buffer')
      map('n', '<leader>gR', gitsigns.reset_buffer, '[R]eset buffer')

      -- Blame
      map('n', '<leader>gb', gitsigns.toggle_current_line_blame, 'Toggle [b]lame')
      map('n', '<leader>gB', function()
        gitsigns.blame_line { full = true }
      end, 'Show [b]lame')

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Git [h]unk')
    end,
  }
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

  require('todo-comments').setup {
    signs = true,
  }

  nmap('[t', '<cmd>lua require("todo-comments").jump_prev()<cr>', 'Previous [t]odo comment')
  nmap(']t', '<cmd>lua require("todo-comments").jump_next()<cr>', 'Next [t]odo comment')
end)

-- Configure windows
later(function()
  add { 'https://github.com/folke/edgy.nvim' }

  require('edgy').setup {
    bottom = {
      'Trouble',
      { ft = 'qf', title = 'QuickFix' },
      {
        title = 'Overseer Output',
        ft = 'OverseerOutput',
      },
      { title = 'Neotest Output', ft = 'neotest-output-panel', size = { height = 15 } },
      { title = 'Undo Tree Diff', ft = 'diff', size = { height = 15 } },
      {
        title = 'Kulala',
        ft = 'json.kulala_ui',
      },
      {
        title = 'Kulala',
        ft = 'text.kulala_ui',
      },
    },
    left = {
      { title = 'Neotest Summary', ft = 'neotest-summary' },
      { title = 'Undo Tree', ft = 'undotree' },
    },
    right = {
      {
        title = 'Grug Far',
        ft = 'grug-far',
        size = { width = 0.3 },
      },
      {
        title = 'Overseer Tasks',
        ft = 'OverseerList',
      },
    },
    keys = {
      ['q'] = false,
      ['<c-q>'] = false,
      ['Q'] = false,
      [']w'] = false,
      ['[w'] = false,
      [']W'] = false,
      ['[W'] = false,
      ['<c-w>>'] = false,
      ['<c-w><lt>'] = false,
      ['<c-w>+'] = false,
      ['<c-w>-'] = false,
      ['<c-w>='] = false,
    },
  }
end)

-- Search and replace
later(function()
  add { 'https://github.com/MagicDuck/grug-far.nvim' }

  require('grug-far').setup {
    keymaps = {
      replace = { n = '<localleader>r' },
      qflist = { n = '<localleader>q' },
      syncLocations = { n = '<localleader>s' },
      syncLine = { n = '<localleader>l' },
      close = { n = '<localleader>c' },
      historyOpen = { n = '<localleader>t' },
      historyAdd = { n = '<localleader>a' },
      refresh = { n = '<localleader>f' },
      openLocation = { n = '<localleader>o' },
      openNextLocation = { n = '<down>' },
      openPrevLocation = { n = '<up>' },
      gotoLocation = { n = '<enter>' },
      pickHistoryEntry = { n = '<enter>' },
      abort = { n = '<localleader>b' },
      help = { n = 'g?' },
      toggleShowCommand = { n = '<localleader>w' },
      swapEngine = { n = '<localleader>e' },
      previewLocation = { n = '<localleader>i' },
      swapReplacementInterpreter = { n = '<localleader>x' },
      applyNext = { n = '<localleader>j' },
      applyPrev = { n = '<localleader>k' },
      syncNext = { n = '<localleader>n' },
      syncPrev = { n = '<localleader>p' },
      syncFile = { n = '<localleader>v' },
      nextInput = { n = '<tab>', i = '<down>' },
      prevInput = { n = '<s-tab>', i = '<up>' },
    },
  }
end)

-- Typescript stuff
require('mini.misc').safely('filetype:typescript,typescriptreact,javascript', function()
  add {
    'https://github.com/pmizio/typescript-tools.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/dmmulroy/ts-error-translator.nvim',
  }

  require('typescript-tools').setup {}
  require('ts-error-translator').setup()
end)

-- Support markdown
require('mini.misc').safely('filetype:markdown', function()
  add {
    'https://github.com/MeanderingProgrammer/render-markdown.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-mini/mini.nvim',
  }

  require('render-markdown').setup()
end)

-- Task runner
later(function()
  add { 'https://github.com/stevearc/overseer.nvim' }

  ---@module "overseer"
  ---@type overseer.SetupOpts
  require('overseer').setup {
    dap = false,
    form = {
      win_opts = {
        winblend = 0,
      },
    },
    task_win = {
      win_opts = {
        winblend = 0,
      },
    },
  }
end)

-- My spear :)
later(function()
  add {
    'https://github.com/diego-velez/spear.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
  }
end)

-- Undo tree
later(function()
  vim.cmd.packadd 'nvim.undotree'
end)

-- Automatically set indentation
now_if_args(function()
  add { 'https://github.com/NMAC427/guess-indent.nvim' }

  ---@type GuessIndentConfig
  require('guess-indent').setup {}
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
      local map = function(lhs, rhs, desc)
        vim.keymap.set('n', lhs, rhs, { buffer = args.buf, desc = desc })
      end

      map('<leader>r', '', '[R]un' )
      map('<leader>rs', kulala.run, '[S]end request' )
      map('<leader>ra', kulala.run_all, 'Send [A]ll requests' )
      map('<leader>rp', kulala.replay, 'Run [P]revious' )
      map('<leader>ru', kulala.toggle_view, 'Toggle UI' )
      map('{', kulala.jump_prev, 'Previous Request' )
      map('}', kulala.jump_next, 'Next Request' )
    end,
  })
end)

-- Extend '%'
later(function()
  vim.pack.add { 'https://github.com/andymass/vim-matchup' }

  ---@type matchup.Config
  require('match-up').setup {}
end)
