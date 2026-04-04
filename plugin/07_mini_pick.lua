Config.later(function()
  require('mini.pick').setup {
    delay = {
      busy = 1,
    },

    mappings = {
      caret_left = '<Left>',
      caret_right = '<Right>',

      choose = '<C-y>',
      choose_in_split = '<C-h>',
      choose_in_vsplit = '<C-v>',
      choose_in_tabpage = '<C-t>',
      choose_marked = '<C-q>',

      delete_char = '<BS>',
      delete_char_right = '<Del>',
      delete_left = '<C-u>',
      delete_word = '<C-w>',

      mark = '<C-x>',
      mark_all = '<C-a>',

      move_down = '<C-n>',
      move_start = '<C-g>',
      move_up = '<C-p>',

      paste = '',

      refine = '<C-CR>',
      refine_marked = '',

      scroll_down = '<C-f>',
      scroll_left = '<C-Left>',
      scroll_right = '<C-Right>',
      scroll_up = '<C-b>',

      stop = '<Esc>',

      toggle_info = '<S-Tab>',
      toggle_preview = '<Tab>',

      another_choose = {
        char = '<CR>',
        func = function()
          local choose_mapping = MiniPick.get_picker_opts().mappings.choose
          vim.api.nvim_input(choose_mapping)
        end,
      },
      actual_paste = {
        char = '<C-r>',
        func = function()
          local content = vim.fn.getreg '+'
          if content ~= '' then
            local current_query = MiniPick.get_picker_query() or {}
            table.insert(current_query, content)
            MiniPick.set_picker_query(current_query)
          end
        end,
      },
    },

    options = {
      use_cache = false,
    },

    window = {
      config = function()
        local height = math.floor(0.5 * vim.o.lines)
        local width = vim.o.columns
        return {
          relative = 'laststatus',
          anchor = 'NW',
          height = height,
          width = width,
          row = 0,
          col = 0,
        }
      end,
      prompt_prefix = '󰁔 ',
      prompt_caret = ' ',
    },
  }

  -- Using primarily for code action
  -- See https://github.com/echasnovski/mini.nvim/discussions/1437
  vim.ui.select = MiniPick.ui_select

  -- Show highlight in buf_lines picker
  -- See https://github.com/echasnovski/mini.nvim/discussions/988#discussioncomment-10398788
  local ns_digit_prefix = vim.api.nvim_create_namespace 'cur-buf-pick-show'
  local show_cur_buf_lines = function(buf_id, items, query, opts)
    if items == nil or #items == 0 then
      return
    end

    -- Show as usual
    MiniPick.default_show(buf_id, items, query, opts)

    -- Move prefix line numbers into inline extmarks
    local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
    local digit_prefixes = {}
    for i, l in ipairs(lines) do
      local _, prefix_end, prefix = l:find '^(%s*%d+│)'
      if prefix_end ~= nil then
        digit_prefixes[i], lines[i] = prefix, l:sub(prefix_end + 1)
      end
    end

    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
    for i, pref in pairs(digit_prefixes) do
      local opts = { virt_text = { { pref, 'MiniPickNormal' } }, virt_text_pos = 'inline' }
      vim.api.nvim_buf_set_extmark(buf_id, ns_digit_prefix, i - 1, 0, opts)
    end

    -- Set highlighting based on the curent filetype
    local ft = vim.bo[items[1].bufnr].filetype
    local has_lang, lang = pcall(vim.treesitter.language.get_lang, ft)
    local has_ts, _ = pcall(vim.treesitter.start, buf_id, has_lang and lang or ft)
    if not has_ts and ft then
      vim.bo[buf_id].syntax = ft
    end
  end

  MiniPick.registry.buf_lines = function()
    -- local local_opts = { scope = 'current', preserve_order = true } -- use preserve_order
    local local_opts = { scope = 'current' }
    MiniExtra.pickers.buf_lines(local_opts, { source = { show = show_cur_buf_lines } })
  end

  -- todo-comments picker section
  local show_todo = function(buf_id, entries, query, opts)
    MiniPick.default_show(buf_id, entries, query, opts)

    -- Add highlighting to every line in the buffer
    for line, entry in ipairs(entries) do
      for _, hl in ipairs(entry.hl) do
        local start = { line - 1, hl[1][1] }
        local finish = { line - 1, hl[1][2] }
        vim.hl.range(
          buf_id,
          ns_digit_prefix,
          hl[2],
          start,
          finish,
          { priority = vim.hl.priorities.user + 1 }
        )
      end
    end
  end

  MiniPick.registry.todo = function()
    require('todo-comments.search').search(function(results)
      -- Don't do anything if there are no todos in the project
      if #results == 0 then
        return
      end

      local Config = require 'todo-comments.config'
      local Highlight = require 'todo-comments.highlight'

      for i, entry in ipairs(results) do
        -- By default, mini.pick uses the path item when an item is choosen to open it
        entry.path = entry.filename
        entry.filename = nil

        local relative_path = string.gsub(entry.path, vim.fn.getcwd() .. '/', '')
        local display = string.format('%s:%s:%s ', relative_path, entry.lnum, entry.col)
        local text = entry.text
        local start, finish, kw = Highlight.match(text)

        entry.hl = {}

        if start then
          kw = Config.keywords[kw] or kw
          local icon = Config.options.keywords[kw].icon or ' '
          display = icon .. display
          table.insert(entry.hl, { { 0, #icon }, 'TodoFg' .. kw })
          text = vim.trim(text:sub(start))

          table.insert(entry.hl, {
            { #display, #display + finish - start + 2 },
            'TodoBg' .. kw,
          })
          table.insert(entry.hl, {
            { #display + finish - start + 1, #display + finish + 1 + #text },
            'TodoFg' .. kw,
          })
          entry.text = display .. ' ' .. text
        end

        results[i] = entry
      end

      MiniPick.start { source = { name = 'Find Todo', show = show_todo, items = results } }
    end)
  end

  ---@class LspPickerOpts
  ---@field scope "declaration" | "definition" | "document_symbol" | "implementation" | "references" | "type_definition" | "workspace_symbol"
  ---@field autojump boolean? If there is only one result it will jump to it.

  -- Open LSP picker for the given scope
  ---@param local_opts LspPickerOpts
  MiniPick.registry.LspPicker = function(local_opts)
    local scope = local_opts.scope

    ---@return string
    local function get_symbol_query()
      return vim.fn.input 'Symbol: '
    end

    ---@param opts vim.lsp.LocationOpts.OnList
    local function on_list(opts)
      vim.fn.setqflist({}, ' ', opts)

      if #opts.items == 1 then
        vim.cmd.cfirst()
      else
        MiniExtra.pickers.list({ scope = 'quickfix' }, {
          source = { name = opts.title },
          window = {
            config = function()
              local height = math.floor(0.618 * vim.o.lines)
              local width = math.floor(0.618 * vim.o.columns)
              return {
                relative = 'cursor',
                anchor = 'NW',
                height = height,
                width = width,
                row = 0,
                col = 0,
              }
            end,
          },
        })
      end
    end

    if scope == 'references' then
      vim.lsp.buf.references(nil, { on_list = on_list })
      return
    end

    if scope == 'workspace_symbol' then
      vim.lsp.buf.workspace_symbol(get_symbol_query(), { on_list = on_list })
      return
    end

    vim.lsp.buf[scope] { on_list = on_list }
  end

  MiniPick.registry.spellsuggest = function()
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
  end
end)
