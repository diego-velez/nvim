local dracula = require('dracula').colors()

local function statuslineActive()
  local section_fileinfo = function(args)
    local filetype = vim.bo.filetype

    -- Don't show anything if there is no filetype
    if filetype == '' then
      return ''
    end

    -- Add filetype icon
    local icon, highlight, _ = MiniIcons.get('filetype', filetype)
    filetype = icon .. ' ' .. filetype

    -- Construct output string if truncated or buffer is not normal
    if MiniStatusline.is_truncated(args.trunc_width) or vim.bo.buftype ~= '' then
      return filetype, highlight
    end

    local get_filesize = function()
      local size = vim.fn.getfsize(vim.fn.getreg '%')
      if size < 1024 then
        return string.format('%dB', size)
      elseif size < 1048576 then
        return string.format('%.2fKB', size / 1024)
      else
        return string.format('%.2fMB', size / 1048576)
      end
    end

    -- Construct output string with extra file info
    local size = get_filesize()

    return string.format('%s %s', filetype, size), highlight
  end

  ---@class FilenameArgs
  ---@field trunc_width number Decides when to trunc to relative path
  ---@field trunc_width_further number Decides when to trunc to filename only

  ---@param args FilenameArgs
  local section_filename = function(args)
    -- In terminal always use plain name
    if vim.bo.buftype == 'terminal' then
      return '%t'
    elseif MiniStatusline.is_truncated(args.trunc_width_further) then
      return '%t%m%r'
    elseif MiniStatusline.is_truncated(args.trunc_width) then
      -- File name with 'truncate', 'modified', 'readonly' flags
      -- Use relative path if truncated
      return '%f%m%r'
    else
      -- Use fullpath if not truncated
      return '%F%m%r'
    end
  end

  local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
  local git = MiniStatusline.section_git { trunc_width = 40 }
  local diff = MiniStatusline.section_diff { trunc_width = 75 }
  local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
  local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
  local filename = section_filename { trunc_width = 140, trunc_width_further = 120 }

  local fileinfo, icon_hl = section_fileinfo { trunc_width = 75 }
  local location = '%2l:%-2v'
  local search = MiniStatusline.section_searchcount { trunc_width = 75 }

  local combine_groups = function(groups)
    local parts = vim.tbl_map(function(s)
      if type(s) == 'string' then
        return s
      end
      if type(s) ~= 'table' then
        return ''
      end

      local string_arr = vim.tbl_filter(function(x)
        return type(x) == 'string' and x ~= ''
      end, s.strings or {})
      local str = table.concat(string_arr, ' ')

      -- Use previous highlight group
      if s.hl == nil then
        return ' ' .. str .. ' '
      end

      -- Allow using this highlight group later
      if str:len() == 0 then
        return '%#' .. s.hl .. '#'
      end

      return string.format('%%#%s#%s', s.hl, str)
    end, groups)

    return table.concat(parts, '')
  end

  local invertHighlightGroup = function(hl_name, hl_colors)
    local hl_name_inverted = hl_name .. 'Invert'

    if hl_colors.reverse then
      vim.api.nvim_set_hl(0, hl_name_inverted, {})
    elseif hl_colors.bg and not hl_colors.fg then
      vim.api.nvim_set_hl(0, hl_name_inverted, { fg = hl_colors.bg, bg = 'bg' })
    elseif hl_colors.fg and not hl_colors.bg then
      vim.api.nvim_set_hl(0, hl_name_inverted, { fg = 'bg', bg = 'bg' })
    else
      vim.api.nvim_set_hl(0, hl_name_inverted, { fg = hl_colors.bg, bg = 'bg' })
    end
    return hl_name_inverted
  end

  -- Invert colors
  local mode_hl_colors = vim.api.nvim_get_hl(0, { name = mode_hl, link = false })
  local mode_hl_invert = invertHighlightGroup(mode_hl, mode_hl_colors)

  -- Setup devinfo and fileinfo section colors
  local dev_hl_invert = ''
  if icon_hl ~= nil then
    local icon_hl_colors = vim.api.nvim_get_hl(0, { name = icon_hl, link = false })
    vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { fg = icon_hl_colors.fg, bg = dracula.menu })

    vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { fg = icon_hl_colors.fg, bg = dracula.menu })
    local dev_hl_colors = vim.api.nvim_get_hl(0, { name = 'MiniStatuslineDevinfo', link = false })
    dev_hl_invert = invertHighlightGroup('MiniStatuslineDevinfo', dev_hl_colors)
  else
    vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { fg = dracula.white, bg = dracula.menu })
    local dev_hl_colors = vim.api.nvim_get_hl(0, { name = 'MiniStatuslineDevinfo', link = false })
    dev_hl_invert = invertHighlightGroup('MiniStatuslineDevinfo', dev_hl_colors)
    vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { fg = dracula.white, bg = dracula.menu })
  end

  -- Setup filename section colors
  vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { fg = dracula.white, bg = 'bg' })

  -- Do not show rounded corners for the dev section
  local devLeftOuter, devRightOuter = '', ''
  if #git + #diff + #diagnostics + #lsp == 0 then
    devLeftOuter, devRightOuter = '', ''
  end

  return combine_groups {
    { hl = mode_hl_invert, strings = { '' } },
    { hl = mode_hl, strings = { mode } },
    { hl = mode_hl_invert, strings = { '' } },
    ' ',
    { hl = dev_hl_invert, strings = { devLeftOuter } },
    { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
    { hl = dev_hl_invert, strings = { devRightOuter } },
    '%<', -- Mark general truncate point
    ' ',
    { hl = 'MiniStatuslineFilename', strings = { filename } },
    '%=', -- End left alignment
    { hl = dev_hl_invert, strings = { '' } },
    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
    { hl = dev_hl_invert, strings = { '' } },
    ' ',
    { hl = mode_hl_invert, strings = { '' } },
    { hl = mode_hl, strings = { search, location } },
    { hl = mode_hl_invert, strings = { '' } },
  }
end

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Disable mini.statusline for certain file types',
  pattern = 'OverseerList',
  callback = function()
    vim.b.ministatusline_disable = true
  end,
})

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require 'mini.statusline'
-- set use_icons to true if you have a Nerd Font
statusline.setup { content = { active = statuslineActive }, use_icons = true }

-- Change the color of the division block by using its highlight group
vim.api.nvim_set_hl(0, 'Statusline', { bg = 'bg' })
