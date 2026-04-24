Config.later(function()
  local augroup = vim.api.nvim_create_augroup('DVT MiniFiles', { clear = true })

  require('mini.files').setup {
    mappings = {
      close = 'q',
      go_in = '',
      go_in_plus = '',
      go_out = '<left>',
      go_out_plus = '',
      mark_set = 'm',
      mark_goto = "'",
      reset = '<BS>',
      reveal_cwd = '@',
      show_help = 'g?',
      synchronize = '<CR>',
      trim_left = '<',
      trim_right = '>',
    },
    options = {
      permanent_delete = false,
    },
    windows = {
      max_number = 1,
    },
  }

  ---Toggle MiniFiles window
  MiniFiles.toggle = function()
    if MiniFiles.close() then
      return
    end

    local current_file = vim.api.nvim_buf_get_name(0)
    -- Needed for starter dashboard
    if vim.fn.filereadable(current_file) == 0 then
      MiniFiles.open()
    else
      MiniFiles.open(current_file, true)
    end
  end

  -- Auto-expand empty & nested dirs
  -- See https://github.com/echasnovski/mini.nvim/discussions/1184
  local expand_single_dir
  expand_single_dir = vim.schedule_wrap(function()
    local is_one_dir = vim.api.nvim_buf_line_count(0) == 1
      and (MiniFiles.get_fs_entry() or {}).fs_type == 'directory'
    if not is_one_dir then
      return
    end
    MiniFiles.go_in { close_on_file = true }
    expand_single_dir()
  end)

  ---Go in entry under cursor, will expand child folders if there is only one child folder,
  ---and if current entry file, expand.
  MiniFiles.go_in_and_expand = function()
    local fs_entry = MiniFiles.get_fs_entry()
    local should_expand = fs_entry ~= nil and fs_entry.fs_type == 'file'

    MiniFiles.go_in { close_on_file = true }

    -- Need to check otherwise it will throw error because the mini.files window was closed
    if not should_expand then
      expand_single_dir()
    end
  end

  ---Opens the selected file in a split (see `:h opening-window`)
  local map_split = function(buf_id, lhs, direction)
    local rhs = function()
      local get_entry = MiniFiles.get_fs_entry()

      -- Don't do anything if dealing with directory
      if get_entry == nil or get_entry.fs_type == 'directory' then
        vim.notify('Cannot split a folder', vim.log.levels.WARN)
        return
      end

      -- Make new window
      local cur_target = MiniFiles.get_explorer_state().target_window
      local new_target = vim.api.nvim_win_call(cur_target, function()
        vim.cmd(direction .. ' split')
        return vim.api.nvim_get_current_win()
      end)

      pcall(vim.fn.win_execute, new_target, 'edit ' .. get_entry.path)
      MiniFiles.close()
      pcall(vim.api.nvim_set_current_win, new_target)
    end

    -- Adding `desc` will result into `show_help` entries
    local desc = 'Split ' .. direction
    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
  end

  -- Toggle dotfiles in window
  local show_dotfiles = true

  local filter_show_all = function()
    return true
  end

  local filter_hide_dotfiles = function(fs_entry)
    return not vim.startswith(fs_entry.name, '.')
  end

  ---Toggle dotfiles in window
  MiniFiles.toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show_all or filter_hide_dotfiles
    MiniFiles.refresh { content = { filter = new_filter } }
  end

  ---Open grug-far on current folder
  MiniFiles.grug_far = function()
    local cur_entry_path = MiniFiles.get_fs_entry().path
    local prefills = { paths = vim.fs.dirname(cur_entry_path) }

    local grug_far = require 'grug-far'

    if not grug_far.has_instance 'explorer' then
      grug_far.open {
        instanceName = 'explorer',
        prefills = prefills,
        staticTitle = 'Find and Replace from Explorer',
      }
    else
      grug_far.get_instance('explorer'):open()
      grug_far.get_instance('explorer'):update_input_values(prefills, false)
    end
  end

  ---Open MiniPick grep_live picker in current folder
  MiniFiles.grep_live = function()
    local curr_entry = MiniFiles.get_fs_entry()
    if not curr_entry then
      return
    end

    local cur_entry_path = curr_entry.path
    local path = vim.fs.dirname(cur_entry_path)

    MiniPick.builtin.grep_live({}, {
      source = {
        cwd = path,
      },
    })
  end

  ---Open MiniPick files picker in current folder
  MiniFiles.files = function()
    local cur_entry_path = MiniFiles.get_fs_entry().path
    local path = vim.fs.dirname(cur_entry_path)

    MiniPick.builtin.files({}, {
      source = {
        cwd = path,
      },
    })
  end

  ---Open file with system default app
  MiniFiles.open_in_app = function()
    local curr_entry = MiniFiles.get_fs_entry()
    if not curr_entry then
      vim.notify('Cursor is not on a valid entry', vim.log.levels.WARN)
      return
    end

    vim.ui.open(curr_entry.path)
  end

  ---Yank in register full path of entry under cursor
  MiniFiles.yank = function()
    local curr_entry = MiniFiles.get_fs_entry()
    if not curr_entry then
      vim.notify('Cursor is not on a valid entry', vim.log.levels.WARN)
      return
    end

    vim.fn.setreg(vim.v.register, curr_entry.path)
  end

  -- Add common bookmarks.
  -- `'c` to navigate into your config directory
  -- `g?` to see available bookmarks
  vim.api.nvim_create_autocmd('User', {
    group = augroup,
    pattern = 'MiniFilesExplorerOpen',
    desc = 'Add bookmarks to mini.files',
    callback = function()
      MiniFiles.set_bookmark('c', vim.fn.stdpath 'config', { desc = 'Config' })
      local vimpack_plugins = vim.fn.stdpath 'data' .. '/site/pack/core/opt'
      MiniFiles.set_bookmark('p', vimpack_plugins, { desc = 'Plugins' })
      MiniFiles.set_bookmark('w', vim.fn.getcwd, { desc = 'Working directory' })
      MiniFiles.set_bookmark('~', '~', { desc = 'Home directory' })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    group = augroup,
    pattern = 'MiniFilesBufferCreate',
    desc = 'Create mappings for MiniFiles explorer',
    callback = function(args)
      local buf_id = args.data.buf_id

      vim.b[buf_id].minianimate_disable = true

      local nmap = function(lhs, rhs, desc)
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
      end

      nmap('G', 'G')
      nmap('<C-u>', '<C-u>')
      nmap('<C-d>', '<C-d>')
      nmap('<right>', MiniFiles.go_in_and_expand, 'Go in and expand')
      map_split(buf_id, '<C-h>', 'belowright horizontal')
      map_split(buf_id, '<C-v>', 'belowright vertical')
      nmap('g.', MiniFiles.toggle_dotfiles, 'Toggle hidden [.]files')
      nmap('<ESC>', MiniFiles.close, 'Close Mini Files')
      nmap('<leader>sR', MiniFiles.grug_far, 'Search and Replace in directory')
      nmap('<leader>sg', MiniFiles.grep_live, 'Grep in directory')
      nmap('<leader>sf', MiniFiles.files, 'Find files in directory')
      nmap('O', MiniFiles.open_in_app, '[O]pen with default app')
      nmap('Y', MiniFiles.yank, '[Y]ank path')
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    group = augroup,
    pattern = 'MiniFilesWindowUpdate',
    desc = 'Show number column in MiniFiles explorer',
    callback = function(args)
      -- Only show number column in the current directory
      local current_buf = args.buf == args.data.buf_id
      vim.wo[args.data.win_id].number = current_buf
      vim.wo[args.data.win_id].relativenumber = current_buf
    end,
  })

  -- LSP Integration
  -- See https://github.com/folke/snacks.nvim/blob/bc0630e43be5699bb94dadc302c0d21615421d93/lua/snacks/rename.lua#L85
  vim.api.nvim_create_autocmd('User', {
    group = augroup,
    pattern = { 'MiniFilesActionRename', 'MiniFilesActionMove' },
    desc = 'MiniFiles LSP Integration',
    callback = function(args)
      local from = args.data.from
      local to = args.data.to
      local lsp_changes = {
        files = {
          {
            oldUri = vim.uri_from_fname(from),
            newUri = vim.uri_from_fname(to),
          },
        },
      }

      local clients = vim.lsp.get_clients()
      for _, client in ipairs(clients) do
        local lsp_rename_files_method = vim.lsp.protocol.Methods.workspace_willRenameFiles
        if client:supports_method(lsp_rename_files_method) then
          local resp = client:request_sync(lsp_rename_files_method, lsp_changes, 1000, 0)
          if resp and resp.result ~= nil then
            vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
          end
        end
      end

      for _, client in ipairs(clients) do
        local lsp_rename_files_method = vim.lsp.protocol.Methods.workspace_didRenameFiles
        if client:supports_method(lsp_rename_files_method) then
          client:notify(lsp_rename_files_method, lsp_changes)
        end
      end
    end,
  })

  -- Git Integration
  vim.api.nvim_create_autocmd('User', {
    group = augroup,
    pattern = { 'MiniFilesActionRename', 'MiniFilesActionMove' },
    desc = 'MiniFiles Git Integration',
    callback = function(args)
      -- We check because if the git add command runs it'll notify the error
      local is_inside_git_repo = vim
        .system({
          'git',
          'rev-parse',
          '--is-inside-work-tree',
        }, { text = true })
        :wait()
      if is_inside_git_repo.code ~= 0 then
        return
      end

      -- Auto add file to Git in order for it to detect that the file was renamed or moved
      local from = args.data.from
      local to = args.data.to
      pcall(vim.cmd, 'Git add ' .. from .. ' ' .. to)
    end,
  })
end)
