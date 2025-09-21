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
    }
  end,
}
