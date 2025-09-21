local now, later = MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

-- NOTE: Start mini.icons configuration
now(function()
  require('mini.icons').setup()
  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)

-- NOTE: Start mini.starter configuration
now(function()
  require 'plugins.mini_starter'
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
  require 'plugins.mini_statusline'
end)

-- NOTE: Start mini.pick configuration
later(function()
  require 'plugins.mini_pick'
end)

-- NOTE: Start mini.git configuration
later(function()
  require('mini.git').setup()
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
  local gen_ai_spec = MiniExtra.gen_ai_spec
  ai.setup {
    n_lines = 500,
    custom_textobjects = {
      -- Code Block
      o = ai.gen_spec.treesitter {
        a = { '@block.outer', '@conditional.outer', '@loop.outer' },
        i = { '@block.inner', '@conditional.inner', '@loop.inner' },
      },

      -- [C]lass
      c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },

      -- [F]unction
      f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },

      -- [B]uffer
      b = gen_ai_spec.buffer(),

      -- [U]sage
      u = ai.gen_spec.function_call(),

      -- [D]igits
      d = gen_ai_spec.number(),
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
    delay = {
      highlight = -1,
    },
  }
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

-- NOTE: Start mini.files configuration
later(function()
  require 'plugins.mini_files'
end)

-- NOTE: Start mini.indentscope configuration
later(function()
  require('mini.indentscope').setup {
    draw = {
      animation = require('mini.indentscope').gen_animation.cubic { duration = 10 },
    },
    options = {
      indent_at_cursor = true,
      try_as_border = true,
    },
    symbol = '│',
  }
end)

-- NOTE: Start mini.comment configuration
later(function()
  require('ts_context_commentstring').setup {
    opts = {
      enable_autocmd = false,
    },
  }
  require('mini.comment').setup {
    options = {
      custom_commentstring = function()
        return require('ts_context_commentstring.internal').calculate_commentstring()
          or vim.bo.commentstring
      end,
    },
  }
end)

-- NOTE: Start mini.clue configuration
later(function()
  local z_clues = function()
    return {
      { mode = 'n', keys = 'zA', desc = 'Toggle folds recursively' },
      { mode = 'n', keys = 'za', desc = 'Toggle fold' },
      { mode = 'n', keys = 'zb', desc = 'Redraw at bottom' },
      { mode = 'n', keys = 'zC', desc = 'Close folds recursively' },
      { mode = 'n', keys = 'zc', desc = 'Close fold' },
      { mode = 'n', keys = 'zD', desc = 'Delete folds recursively' },
      { mode = 'n', keys = 'zd', desc = 'Delete fold' },
      { mode = 'n', keys = 'zE', desc = 'Eliminate all folds' },
      { mode = 'n', keys = 'ze', desc = 'Scroll to cursor on right screen side' },
      { mode = 'n', keys = 'zF', desc = 'Create fold' },
      { mode = 'n', keys = 'zf', desc = 'Create fold (operator)' },
      { mode = 'n', keys = 'zG', desc = 'Temporarily mark as correctly spelled' },
      { mode = 'n', keys = 'zg', desc = 'Permanently mark as correctly spelled' },
      { mode = 'n', keys = 'zH', desc = 'Scroll left half screen' },
      { mode = 'n', keys = 'z<left>', desc = 'Scroll left', postkeys = 'z' },
      { mode = 'n', keys = 'zi', desc = "Toggle 'foldenable'" },
      { mode = 'n', keys = 'zj', desc = 'Move to start of next fold' },
      { mode = 'n', keys = 'zk', desc = 'Move to end of previous fold' },
      { mode = 'n', keys = 'zL', desc = 'Scroll right half screen' },
      { mode = 'n', keys = 'z<right>', desc = 'Scroll right', postkeys = 'z' },
      { mode = 'n', keys = 'zM', desc = 'Close all folds' },
      { mode = 'n', keys = 'zm', desc = 'Fold more' },
      { mode = 'n', keys = 'zN', desc = "Set 'foldenable'" },
      { mode = 'n', keys = 'zn', desc = "Reset 'foldenable'" },
      { mode = 'n', keys = 'zO', desc = 'Open folds recursively' },
      { mode = 'n', keys = 'zo', desc = 'Open fold' },
      { mode = 'n', keys = 'zP', desc = 'Paste without trailspace' },
      { mode = 'n', keys = 'zp', desc = 'Paste without trailspace' },
      { mode = 'n', keys = 'zR', desc = 'Open all folds' },
      { mode = 'n', keys = 'zr', desc = 'Fold less' },
      { mode = 'n', keys = 'zs', desc = 'Scroll to cursor on left screen side' },
      { mode = 'n', keys = 'zt', desc = 'Redraw at top' },
      { mode = 'n', keys = 'zu', desc = '+Undo spelling commands' },
      { mode = 'n', keys = 'zug', desc = 'Undo `zg`' },
      { mode = 'n', keys = 'zuG', desc = 'Undo `zG`' },
      { mode = 'n', keys = 'zuw', desc = 'Undo `zw`' },
      { mode = 'n', keys = 'zuW', desc = 'Undo `zW`' },
      { mode = 'n', keys = 'zv', desc = 'Open enough folds' },
      { mode = 'n', keys = 'zW', desc = 'Temporarily mark as incorrectly spelled' },
      { mode = 'n', keys = 'zw', desc = 'Permanently mark as incorrectly spelled' },
      { mode = 'n', keys = 'zX', desc = 'Update folds' },
      { mode = 'n', keys = 'zx', desc = 'Update folds + open enough folds' },
      { mode = 'n', keys = 'zy', desc = 'Yank without trailing spaces (operator)' },
      { mode = 'n', keys = 'zz', desc = 'Redraw at center' },
      { mode = 'n', keys = 'z+', desc = 'Redraw under bottom at top' },
      { mode = 'n', keys = 'z-', desc = 'Redraw at bottom + cursor on first non-blank' },
      { mode = 'n', keys = 'z.', desc = 'Redraw at center + cursor on first non-blank' },
      { mode = 'n', keys = 'z=', desc = 'Show spelling suggestions' },
      { mode = 'n', keys = 'z^', desc = 'Redraw above top at bottom' },

      { mode = 'x', keys = 'zf', desc = 'Create fold from selection' },
    }
  end

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
      vim.tbl_extend('force', miniclue.gen_clues.windows { submode_resize = true }, {
        { mode = 'n', keys = '<C-w><left>', desc = 'Focus left', postkeys = '<C-w>' },
        { mode = 'n', keys = '<C-w><right>', desc = 'Focus right', postkeys = '<C-w>' },
        { mode = 'n', keys = '<C-w><up>', desc = 'Focus top', postkeys = '<C-w>' },
        { mode = 'n', keys = '<C-w><down>', desc = 'Focus bottom', postkeys = '<C-w>' },
      }),
      z_clues(),
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
    buffer = { suffix = '', options = {} },
    comment = { suffix = '', options = {} },
    conflict = { suffix = '', options = {} },
    diagnostic = { suffix = '', options = {} },
    file = { suffix = 'f', options = {} },
    indent = { suffix = '', options = {} },
    jump = { suffix = 'j', options = {} },
    location = { suffix = '', options = {} },
    oldfile = { suffix = 'o', options = {} },
    quickfix = { suffix = '', options = {} },
    treesitter = { suffix = '', options = {} },
    undo = { suffix = '', options = {} },
    window = { suffix = '', options = {} },
    yank = { suffix = '', options = {} },
  }
end)

-- NOTE: Start mini.snippets configuration
later(function()
  local gen_loader = require('mini.snippets').gen_loader
  require('mini.snippets').setup {
    snippets = {
      -- Load custom file with global snippets first (adjust for Windows)
      gen_loader.from_file '~/.config/nvim/snippets/global.json',

      -- Load snippets based on current language by reading files from
      -- "snippets/" subdirectories from 'runtimepath' directories.
      gen_loader.from_lang(),
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

  local tab_steps = { 'minisnippets_expand', 'minisnippets_next' }
  map_multistep('i', '<tab>', tab_steps)
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
later(function()
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
    -- Buffer words completion
    -- See `:h ins-completion`
    fallback_action = '<C-n>',
    mappings = {
      force_twostep = '',
      force_fallback = '<C-CR>',
    },
  }

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

-- Keymaps

vim.keymap.set('n', '<leader>th', function()
  MiniHipatterns.toggle(0)
  vim.g.highlighting_enabled = not vim.g.highlighting_enabled

  if vim.g.highlighting_enabled then
    vim.notify('Highlighting enabled', vim.log.levels.INFO)
  else
    vim.notify('Highlighting disabled', vim.log.levels.INFO)
  end
end, { desc = 'Toggle [H]ighlighting' })

vim.keymap.set('n', '<leader>/', function()
  MiniPick.registry.buf_lines()
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>so', function()
  MiniExtra.pickers.oldfiles()
end, { desc = '[S]earch [O]ld Files' })
vim.keymap.set('n', '<leader>sr', function()
  MiniPick.builtin.resume()
end, { desc = '[S]earch [R]esume' })

local ns = vim.api.nvim_create_namespace 'DVT MiniPickRanges'
vim.keymap.set('n', '<leader>sg', function()
  local show = function(buf_id, items, query)
    local hl_groups = {}
    items = vim.tbl_map(function(item)
      -- Get all items as returned by ripgrep
      local path, row, column, str = string.match(item, '^([^|]*)|([^|]*)|([^|]*)|(.*)$')

      path = vim.fs.basename(path)

      -- Trim text found
      str = string.gsub(str, '^%s*(.-)%s*$', '%1')

      local icon, hl = MiniIcons.get('file', path)
      table.insert(hl_groups, hl)

      return string.format('%s %s|%s|%s| %s', icon, path, row, column, str)
    end, items)

    MiniPick.default_show(buf_id, items, query, { show_icons = false })

    -- Add color to icons
    local icon_extmark_opts = { hl_mode = 'combine', priority = 210 }
    for i = 1, #hl_groups do
      icon_extmark_opts.hl_group = hl_groups[i]
      icon_extmark_opts.end_row, icon_extmark_opts.end_col = i - 1, 1
      vim.api.nvim_buf_set_extmark(buf_id, ns, i - 1, 0, icon_extmark_opts)
    end
  end

  local set_items_opts = { do_match = false, querytick = 0 }
  local process
  local match = function(_, _, query)
    pcall(vim.loop.process_kill, process)
    if #query == 0 then
      return MiniPick.set_picker_items({}, set_items_opts)
    end

    local command = {
      'rg',
      '--column',
      '--line-number',
      '--no-heading',
      '--field-match-separator',
      '|',
      '--no-follow',
      '--color=never',
      '--',
      table.concat(query),
    }
    process = MiniPick.set_picker_items_from_cli(
      command,
      { set_items_opts = set_items_opts, spawn_opts = { cwd = vim.uv.cwd() } }
    )
  end

  local choose = function(item)
    local path, row, column = string.match(item, '^([^|]*)|([^|]*)|([^|]*)|.*$')
    local chosen = {
      path = path,
      lnum = tonumber(row),
      col = tonumber(column),
    }
    MiniPick.default_choose(chosen)
  end

  MiniPick.start {
    source = {
      name = 'Live Grep',
      items = {},
      match = match,
      show = show,
      choose = choose,
    },
  }
end, { desc = '[S]earch [G]rep' })
vim.keymap.set('n', '<leader>sG', function()
  vim.ui.input({
    prompt = 'What directory do you want to search in? ',
    default = vim.uv.cwd(),
    completion = 'dir',
  }, function(input)
    if not input or input == '' then
      return
    end

    MiniPick.builtin.grep_live({}, { source = { cwd = input } })
  end)
end, { desc = '[S]earch [G]rep in specific directory' })
vim.keymap.set('n', '<leader>sw', function()
  local cword = vim.fn.expand '<cword>'
  vim.defer_fn(function()
    MiniPick.set_picker_query { cword }
  end, 25)
  MiniPick.builtin.grep_live()
end, { desc = '[S]earch [W]ord' })

-- Use fff.nvim if it is available
-- Fallback to MiniPick.builtin.files
local fff_is_available, fff = pcall(require, 'fff')
if fff_is_available then
  fff.setup { ui = { picker = 'mini' } }
end
vim.keymap.set('n', '<leader>sf', function()
  if fff_is_available then
    fff.find_files()
  else
    MiniPick.registry.files()
  end
end, { desc = '[S]earch [F]iles' }) -- See https://github.com/echasnovski/mini.nvim/discussions/1873
vim.keymap.set('n', '<leader><space>', function()
  if fff_is_available then
    fff.find_files()
  else
    MiniPick.registry.files()
  end
end, { desc = 'Search Files' })
vim.keymap.set('n', '<leader>sF', function()
  vim.ui.input({
    prompt = 'What directory do you want to search in? ',
    default = vim.uv.cwd(),
    completion = 'dir',
  }, function(input)
    if not input or input == '' then
      return
    end

    if fff_is_available then
      fff.find_files_in_dir(input)
      fff.change_indexing_directory(vim.uv.cwd())
    else
      MiniPick.registry.files()
    end
  end)
end, { desc = '[S]earch [F]iles in specific directory' })
vim.keymap.set('n', '<leader>sc', function()
  local config_path = vim.fn.stdpath 'config'
  if fff_is_available then
    fff.find_files_in_dir(config_path)
    fff.change_indexing_directory(vim.uv.cwd())
  else
    MiniPick.registry.files(nil, {
      source = {
        cwd = config_path,
      },
    })
  end
end, { desc = '[S]earch [C]onfig' })

vim.keymap.set('n', '<leader>sh', function()
  MiniPick.builtin.help { default_split = 'vertical' }
end, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>st', function()
  MiniPick.registry.todo()
end, { desc = '[S]earch [T]odo' })
vim.keymap.set('n', '<leader>ss', function()
  MiniExtra.pickers.lsp { scope = 'document_symbol' }
end, { desc = '[S]earch [S]ymbols' })
vim.keymap.set('n', '<leader>sH', function()
  MiniExtra.pickers.history()
end, { desc = '[S]earch [H]istory' })
vim.keymap.set('n', '<leader>sd', function()
  MiniExtra.pickers.diagnostic()
end, { desc = '[S]earch [D]iagnostic' })
vim.keymap.set('n', '<leader>sb', function()
  MiniPick.builtin.buffers()
end, { desc = '[S]earch [B]uffers' })
vim.keymap.set('n', '<leader>n', function()
  vim.cmd.tabnew()
  MiniNotify.show_history()
end, { desc = '[N]otification History' })
vim.keymap.set('n', '<leader>sC', function()
  MiniExtra.pickers.colorschemes(nil, nil)
end, { desc = '[S]earch [C]olorscheme' })
vim.keymap.set('n', 'z=', function()
  local word = vim.fn.expand '<cword>'
  MiniExtra.pickers.spellsuggest(nil, {
    window = {
      config = function()
        local height = math.floor(0.2 * vim.o.lines)
        local width = math.floor(math.max(vim.fn.strdisplaywidth(word) + 2, 20))
        return {
          relative = 'cursor',
          anchor = 'NW',
          height = height,
          width = width,
          row = 1, -- I want to see <cword>
          col = -1, -- Aligned nicely with <cword>
        }
      end,
    },
  })
end, { desc = 'Show spellings suggestions' })
