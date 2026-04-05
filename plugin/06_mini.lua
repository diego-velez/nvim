local now, later = Config.now, Config.later
local now_if_args = Config.now_if_args

-- NOTE: Start mini.icons configuration
now(function()
  require('mini.icons').setup()
  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)

-- NOTE: Start mini.notify configuration
now(function()
  require('mini.notify').setup {
    content = {
      -- Add notifications to the bottom
      sort = function(notif_arr)
        table.sort(notif_arr, function(a, b)
          return a.ts_update < b.ts_update
        end)
        return notif_arr
      end,
    },
    window = {
      winblend = 0,
    },
  }
  vim.notify = MiniNotify.make_notify()
end)

-- NOTE: Start mini.statusline configuration
now_if_args(function()
  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = vim.g.have_nerd_font }
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function()
    return '%2l:%-2v'
  end
end)

-- NOTE: Start mini.tabline configuration
now_if_args(function()
  require('mini.tabline').setup()
end)

-- NOTE: Start mini.git configuration
later(function()
  require('mini.git').setup()
end)

-- NOTE: Start mini.diff configuration
later(function()
  require('mini.diff').setup()
end)

-- NOTE: Start mini.extra configuration
later(function()
  require('mini.extra').setup()
end)

-- NOTE: Start mini.hipatterns configuration
later(function()
  local patterns = require 'mini.hipatterns'
  patterns.setup {
    highlighters = {
      hex_color = patterns.gen_highlighter.hex_color { priority = 2000 },
      shorthand = {
        pattern = '()#%x%x%x()%f[^%x%w_]',
        group = function(_, _, data)
          ---@type string
          local match = data.full_match
          local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
          local hex_color = '#' .. r .. r .. g .. g .. b .. b

          return patterns.compute_hex_color_group(hex_color, 'bg')
        end,
        extmark_opts = { priority = 2000 },
      },
    },
  }
end)

-- NOTE: Start mini.ai configuration
later(function()
  local ai = require 'mini.ai'
  ai.setup {
    custom_textobjects = {
      -- Code Block
      o = ai.gen_spec.treesitter {
        a = { '@conditional.outer', '@loop.outer' },
        i = { '@conditional.inner', '@loop.inner' },
      },

      -- [C]lass
      c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },

      -- [F]unction
      f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },

      -- [B]uffer
      b = MiniExtra.gen_ai_spec.buffer(),

      -- [U]sage
      u = ai.gen_spec.function_call(),

      -- [D]igits
      d = MiniExtra.gen_ai_spec.number(),
    },

    mappings = {
      around_next = '',
      inside_next = '',
      around_last = '',
      inside_last = '',

      goto_left = '',
      goto_right = '',
    },
  }
end)

-- NOTE: Start mini.surround configuration
later(function()
  require('mini.surround').setup {
    mappings = {
      add = 'ys',
      delete = 'ds',
      find = '',
      find_left = '',
      highlight = '',
      replace = 'cs',
      update_n_lines = '',
    },
  }

  -- Remap adding surrounding to Visual mode selection
  vim.keymap.del('x', 'ys')
  vim.keymap.set('x', 's', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

  -- Make special mapping for "add surrounding for line"
  vim.keymap.set('n', 'yss', 'ys_', { remap = true })
end)

-- NOTE: Start mini.jump configuration
later(function()
  require('mini.jump').setup {
    mappings = {
      repeat_jump = '',
    },
  }

  -- To determine if we're currently in ',' backward F/T state
  local in_backward = false

  --MiniJump to the opposite direction
  local function jump_opposite(target, backward, till)
    if backward then
      MiniJump.jump(target, false, till)
    else
      MiniJump.jump(target, true, till)
    end
  end

  vim.keymap.set('n', ',', function()
    local state = MiniJump.state

    -- Allow re-doing previous jump, only if there is a previous jump
    if not state.target then
      return
    end

    local target = state.target
    local backward = state.backward
    local till = state.till

    -- If we're currently in ',' state, then we cannot invert jump direction
    if in_backward then
      MiniJump.jump(target, backward, till)
      return
    end

    jump_opposite(target, backward, till)
    in_backward = true
  end)

  vim.keymap.set('n', ';', function()
    local state = MiniJump.state

    -- Allow re-doing previous jump, only if there is a previous jump
    if not state.target then
      return
    end

    local target = state.target
    local backward = state.backward
    local till = state.till

    -- If we're currently in ',' state, then we need to invert jump direction
    if in_backward then
      jump_opposite(target, backward, till)
      in_backward = false
      return
    end

    MiniJump.jump(target, backward, till)
  end)

  local augroup = vim.api.nvim_create_augroup('MiniJump Highlighting', { clear = true })
  vim.api.nvim_create_autocmd('User', {
    desc = 'Disable highliting when in jump',
    pattern = 'MiniJumpStart',
    group = augroup,
    callback = function()
      vim.b.minicursorword_disable = true
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    desc = 'Enable highliting when not in jump',
    pattern = 'MiniJumpStop',
    group = augroup,
    callback = function()
      vim.b.minicursorword_disable = false
    end,
  })
end)

-- NOTE: Start mini.pairs configuration
later(function()
  require('mini.pairs').setup {
    modes = {
      insert = true,
      command = true,
      terminal = false,
    },
    -- skip autopair when next character is one of these
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    -- skip autopair when the cursor is inside these treesitter nodes
    skip_ts = { 'string' },
    -- skip autopair when next character is closing pair
    -- and there are more closing pairs than opening pairs
    skip_unbalanced = true,
    -- better deal with markdown code blocks
    markdown = true,
  }
end)

-- NOTE: Start mini.indentscope configuration
later(function()
  require('mini.indentscope').setup {
    draw = {
      animation = require('mini.indentscope').gen_animation.cubic { duration = 10 },
    },
    options = {
      indent_at_cursor = false,
      try_as_border = true,
    },
    symbol = '│',
  }
end)

-- NOTE: Start mini.comment configuration
later(function()
  require('mini.comment').setup()
end)

-- NOTE: Start mini.clue configuration
later(function()
  -- stylua: ignore start
  local z_clues = {
      { mode = 'n', keys = 'zA',       desc = 'Toggle folds recursively' },
      { mode = 'n', keys = 'za',       desc = 'Toggle fold' },
      { mode = 'n', keys = 'zb',       desc = 'Redraw at bottom' },
      { mode = 'n', keys = 'zC',       desc = 'Close folds recursively' },
      { mode = 'n', keys = 'zc',       desc = 'Close fold' },
      { mode = 'n', keys = 'zD',       desc = 'Delete folds recursively' },
      { mode = 'n', keys = 'zd',       desc = 'Delete fold' },
      { mode = 'n', keys = 'zE',       desc = 'Eliminate all folds' },
      { mode = 'n', keys = 'ze',       desc = 'Scroll to cursor on right screen side' },
      { mode = 'n', keys = 'zF',       desc = 'Create fold' },
      { mode = 'n', keys = 'zf',       desc = 'Create fold (operator)' },
      { mode = 'n', keys = 'zG',       desc = 'Temporarily mark as correctly spelled' },
      { mode = 'n', keys = 'zg',       desc = 'Permanently mark as correctly spelled' },
      { mode = 'n', keys = 'zH',       desc = 'Scroll left half screen' },
      { mode = 'n', keys = 'z<left>',  desc = 'Scroll left',  postkeys = 'z' },
      { mode = 'n', keys = 'zi',       desc = "Toggle 'foldenable'" },
      { mode = 'n', keys = 'zj',       desc = 'Move to start of next fold' },
      { mode = 'n', keys = 'zk',       desc = 'Move to end of previous fold' },
      { mode = 'n', keys = 'zL',       desc = 'Scroll right half screen' },
      { mode = 'n', keys = 'z<right>', desc = 'Scroll right', postkeys = 'z' },
      { mode = 'n', keys = 'zM',       desc = 'Close all folds' },
      { mode = 'n', keys = 'zm',       desc = 'Fold more' },
      { mode = 'n', keys = 'zN',       desc = "Set 'foldenable'" },
      { mode = 'n', keys = 'zn',       desc = "Reset 'foldenable'" },
      { mode = 'n', keys = 'zO',       desc = 'Open folds recursively' },
      { mode = 'n', keys = 'zo',       desc = 'Open fold' },
      { mode = 'n', keys = 'zP',       desc = 'Paste without trailspace' },
      { mode = 'n', keys = 'zp',       desc = 'Paste without trailspace' },
      { mode = 'n', keys = 'zR',       desc = 'Open all folds' },
      { mode = 'n', keys = 'zr',       desc = 'Fold less' },
      { mode = 'n', keys = 'zs',       desc = 'Scroll to cursor on left screen side' },
      { mode = 'n', keys = 'zt',       desc = 'Redraw at top' },
      { mode = 'n', keys = 'zu',       desc = '+Undo spelling commands' },
      { mode = 'n', keys = 'zug',      desc = 'Undo `zg`' },
      { mode = 'n', keys = 'zuG',      desc = 'Undo `zG`' },
      { mode = 'n', keys = 'zuw',      desc = 'Undo `zw`' },
      { mode = 'n', keys = 'zuW',      desc = 'Undo `zW`' },
      { mode = 'n', keys = 'zv',       desc = 'Open enough folds' },
      { mode = 'n', keys = 'zW',       desc = 'Temporarily mark as incorrectly spelled' },
      { mode = 'n', keys = 'zw',       desc = 'Permanently mark as incorrectly spelled' },
      { mode = 'n', keys = 'zX',       desc = 'Update folds' },
      { mode = 'n', keys = 'zx',       desc = 'Update folds + open enough folds' },
      { mode = 'n', keys = 'zy',       desc = 'Yank without trailing spaces (operator)' },
      { mode = 'n', keys = 'zz',       desc = 'Redraw at center' },
      { mode = 'n', keys = 'z+',       desc = 'Redraw under bottom at top' },
      { mode = 'n', keys = 'z-',       desc = 'Redraw at bottom + cursor on first non-blank' },
      { mode = 'n', keys = 'z.',       desc = 'Redraw at center + cursor on first non-blank' },
      { mode = 'n', keys = 'z=',       desc = 'Show spelling suggestions' },
      { mode = 'n', keys = 'z^',       desc = 'Redraw above top at bottom' },
      { mode = 'x', keys = 'zf',       desc = 'Create fold from selection' },
    }

  local window_clues = {
    { mode = 'n', keys = '<C-w>+',       desc = 'Increase height',         postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>-',       desc = 'Decrease height',         postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w><',       desc = 'Decrease width',          postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>>',       desc = 'Increase width',          postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>=',       desc = 'Make windows same dimensions' },
    { mode = 'n', keys = '<C-w>]',       desc = 'Split + jump to tag' },
    { mode = 'n', keys = '<C-w>^',       desc = 'Split + edit alternate file' },
    { mode = 'n', keys = '<C-w>_',       desc = 'Set height (def: very high)' },
    { mode = 'n', keys = '<C-w>|',       desc = 'Set width (def: very wide)' },
    { mode = 'n', keys = '<C-w>}',       desc = 'Show tag in preview' },
    { mode = 'n', keys = '<C-w>c',       desc = 'Close' },
    { mode = 'n', keys = '<C-w>d',       desc = 'Split + jump to definition' },
    { mode = 'n', keys = '<C-w>F',       desc = 'Split + edit file name + jump' },
    { mode = 'n', keys = '<C-w>f',       desc = 'Split + edit file name' },
    { mode = 'n', keys = '<C-w>g',       desc = '+Extra actions' },
    { mode = 'n', keys = '<C-w>g]',      desc = 'Split + list tags' },
    { mode = 'n', keys = '<C-w>g}',      desc = 'Do `:ptjump`' },
    { mode = 'n', keys = '<C-w>g<C-]>',  desc = 'Split + jump to tag with `:tjump`' },
    { mode = 'n', keys = '<C-w>g<Tab>',  desc = 'Focus last accessed tab', postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>gF',      desc = 'New tabpage + edit file name + jump' },
    { mode = 'n', keys = '<C-w>gf',      desc = 'New tabpage + edit file name' },
    { mode = 'n', keys = '<C-w>gT',      desc = 'Focus previous tabpage',  postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>gt',      desc = 'Focus next tabpage',      postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>H',       desc = 'Move to very left',       postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w><left>',  desc = 'Focus left',              postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>i',       desc = 'Split + jump to declaration' },
    { mode = 'n', keys = '<C-w><down>',  desc = 'Focus down',              postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w><up>',    desc = 'Focus up',                postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w><right>', desc = 'Focus right',             postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>n',       desc = 'Open new' },
    { mode = 'n', keys = '<C-w>o',       desc = 'Close all but current' },
    { mode = 'n', keys = '<C-w>P',       desc = 'Focus preview',           postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>p',       desc = 'Focus last accessed',     postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>q',       desc = 'Quit current' },
    { mode = 'n', keys = '<C-w>R',       desc = 'Rotate up/left',          postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>r',       desc = 'Rotate down/right',       postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>s',       desc = 'Split horizontally' },
    { mode = 'n', keys = '<C-w>T',       desc = 'Create new tabpage + move' },
    { mode = 'n', keys = '<C-w>v',       desc = 'Split vertically' },
    { mode = 'n', keys = '<C-w>W',       desc = 'Focus previous',          postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>w',       desc = 'Focus next',              postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>x',       desc = 'Exchange windows',        postkeys = '<C-w>'},
    { mode = 'n', keys = '<C-w>z',       desc = 'Close preview' },
  }
  -- stylua: ignore end

  local miniclue = require 'mini.clue'
  miniclue.setup {
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },

      -- Brackets
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
    },

    clues = {
      {
        { mode = 'n', keys = '<leader>t', desc = '[T]oggle' },
        { mode = 'n', keys = '<leader>c', desc = '[C]ode' },
        { mode = 'n', keys = '<leader>s', desc = '[S]earch' },
        { mode = 'n', keys = '<leader>l', desc = '[L]ist' },
        { mode = 'n', keys = '<leader>o', desc = '[O]verseer' },
        { mode = 'n', keys = '<leader>u', desc = 'UI' },
        { mode = 'n', keys = '<leader><tab>', desc = 'Tabs' },
        { mode = 'n', keys = '<leader>g', desc = '[G]it' },
        { mode = 'x', keys = '<leader>g', desc = '[G]it' },
      },
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.square_brackets(),
      z_clues,
      window_clues,
    },

    window = {
      config = {
        width = 50,
      },
      delay = 0,
    },
  }
end)

-- NOTE: Start mini.cursorword configuration
later(function()
  require('mini.cursorword').setup()
  local lspRefTextHl = vim.api.nvim_get_hl(0, { name = 'LspReferenceText', link = false })
  vim.api.nvim_set_hl(
    0,
    'MiniCursorword',
    { fg = lspRefTextHl.fg, bg = lspRefTextHl.bg, underline = true }
  )
end)

-- NOTE: Start mini.animate configuration
later(function()
  -- don't use animate when scrolling with the mouse
  local mouse_scrolled = false
  for _, scroll in ipairs { 'Up', 'Down' } do
    local key = '<ScrollWheel' .. scroll .. '>'
    vim.keymap.set({ '', 'i' }, key, function()
      mouse_scrolled = true
      return key
    end, { expr = true })
  end

  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Disable mini.animate for Grug-Far',
    pattern = 'grug-far',
    callback = function()
      vim.b.minianimate_disable = true
    end,
  })

  local animate = require 'mini.animate'
  animate.setup {
    cursor = {
      enable = false,
    },
    resize = {
      timing = animate.gen_timing.linear { duration = 50, unit = 'total' },
    },
    scroll = {
      timing = animate.gen_timing.linear { duration = 150, unit = 'total' },
      subscroll = animate.gen_subscroll.equal {
        predicate = function(total_scroll)
          if mouse_scrolled then
            mouse_scrolled = false
            return false
          end
          return total_scroll > 1
        end,
      },
    },
  }
end)

-- NOTE: Start mini.splitjoin configuration
later(function()
  require('mini.splitjoin').setup()
end)

-- NOTE: Start mini.trailspace configuration
later(function()
  require('mini.trailspace').setup()
end)

-- NOTE: Start mini.bufremove configuration
later(function()
  require('mini.bufremove').setup()
end)

-- NOTE: Start mini.bracketed configuration
later(function()
  require('mini.bracketed').setup {
    indent = { suffix = '' },
  }
end)

-- NOTE: Start mini.snippets configuration
later(function()
  local snippets = require 'mini.snippets'
  local config_path = vim.fn.stdpath 'config'
  snippets.setup {
    snippets = {
      -- Load custom file with global snippets first (adjust for Windows)
      snippets.gen_loader.from_file(config_path .. '/snippets/global.json'),

      -- Load snippets based on current language by reading files from
      -- "snippets/" subdirectories from 'runtimepath' directories.
      snippets.gen_loader.from_lang(),
    },
    mappings = {
      -- Expand snippet at cursor position. Created globally in Insert mode.
      expand = '',

      -- Interact with default `expand.insert` session.
      -- Created for the duration of active session(s)
      jump_next = '',
      jump_prev = '',
      stop = '<C-e>',
    },
    expand = {
      match = function(snips)
        return require('mini.snippets').default_match(snips, { pattern_fuzzy = '%S+' })
      end,
    },
  }

  local map_multistep = require('mini.keymap').map_multistep

  map_multistep('i', '<tab>', { 'minisnippets_expand', 'minisnippets_next' })
  map_multistep('i', '<S-tab>', { 'minisnippets_prev' })

  vim.api.nvim_create_autocmd('User', {
    desc = 'Automatically stop mini.snippets when exiting insert mode',
    group = vim.api.nvim_create_augroup('DVT MiniSnippets', { clear = true }),
    pattern = 'MiniSnippetsSessionStart',
    callback = function()
      vim.api.nvim_create_autocmd('ModeChanged', {
        pattern = '*:n',
        once = true,
        callback = function()
          while MiniSnippets.session.get() do
            MiniSnippets.session.stop()
          end
        end,
      })
    end,
  })
end)

-- NOTE: Start mini.completion configuration
now_if_args(function()
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end
  require('mini.completion').setup {
    delay = {
      completion = 0,
      info = 0,
      signature = 0,
    },
    window = {
      info = {
        border = 'rounded',
      },
      signature = {
        border = 'rounded',
      },
    },
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = process_items,
    },
    -- Buffer words completion
    -- See `:h ins-completion`
    fallback_action = '<C-n>',
    mappings = {
      force_twostep = '',
      force_fallback = '<C-CR>',
    },
  }

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('mini.completion setup', {}),
    desc = "Set 'omnifunc'",
    callback = function(ev)
      vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end,
  })

  ---@type lsp.ClientCapabilities
  local capabilities_override = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        },
      },
    },
  }
  local capabilities = vim.tbl_deep_extend(
    'force',
    vim.lsp.protocol.make_client_capabilities(),
    MiniCompletion.get_lsp_capabilities(),
    capabilities_override
  )
  vim.lsp.config('*', { capabilities = capabilities })

  -- I want to use Ctrl+n to trigger completion and cycle to next completion too
  require('mini.keymap').map_multistep('i', '<C-n>', {
    'pmenu_next',
    {
      condition = function()
        return _G.MiniCompletion ~= nil
      end,
      action = MiniCompletion.complete_twostage,
    },
  })

  -- Do not use arrow keys for completion menu
  vim.keymap.set('i', '<down>', function()
    if vim.fn.pumvisible() == 1 then
      return '<C-e><down>'
    end
    return '<down>'
  end, { expr = true })
  vim.keymap.set('i', '<up>', function()
    if vim.fn.pumvisible() == 1 then
      return '<C-e><up>'
    end
    return '<up>'
  end, { expr = true })

  -- Auto traverse filepaths in autocomplete
  local function simulate_keypress(key)
    local termcodes = vim.api.nvim_replace_termcodes(key, true, false, true)
    vim.api.nvim_feedkeys(termcodes, 'm', false)
  end

  vim.api.nvim_create_autocmd('CompleteDone', {
    desc = 'Autocompletion for multiple file path components',
    group = vim.api.nvim_create_augroup('DVT MiniCompletion', { clear = true }),
    callback = function()
      if vim.v.event.complete_type == 'files' and vim.v.event.reason == 'accept' then
        simulate_keypress '<c-x>'
        simulate_keypress '<c-f>'
      end
    end,
  })
end)

-- NOTE: Start mini.align configuration
later(function()
  require('mini.align').setup()
end)

-- NOTE: Start mini.cmdline configuration
later(function()
  require('mini.cmdline').setup()
end)

-- NOTE: Start mini.move configuration
later(function()
  require('mini.move').setup {
    mappings = {
      left = '<',
      right = '>',
      down = 'k',
      up = 'j',

      line_left = '<',
      line_right = '>',
      line_down = 'k',
      line_up = 'j',
    },
  }
end)

-- NOTE: Start mini.misc configuration
now_if_args(function()
  require('mini.misc').setup()

  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)
