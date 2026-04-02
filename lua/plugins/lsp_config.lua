vim.lsp.log.set_level(vim.log.levels.OFF)

require('mason').setup {
  ui = {
    keymaps = {
      toggle_help = '?',
    },
  },
}

require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    { path = 'wezterm-types', mods = { 'wezterm' } },
    { path = '$HOME/.local/share/LuaAddons/', words = { 'love.' } },
  },
}

-- Configure Java specific stuff separately
require('java').setup {}

-- Kotlin LSP needs JDK 17 or greater
local java_output = vim.system({ 'mise', 'where', 'java@17' }, { text = true }):wait()
local java_home_for_lsp
if java_output.code ~= 0 then
  vim.notify('Could not set up Kotlin LSP', vim.log.levels.ERROR)
else
  -- Output has '\n' at the end, remove that shit here
  java_home_for_lsp = java_output.stdout:gsub('\n', '')
end

local servers = {
  gopls = {
    settings = {
      gopls = {
        ['ui.inlayhint.hints'] = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  },
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'openFilesOnly',
          useLibraryCodeForTypes = true,
          diagnosticSeverityOverrides = {
            reportUnusedCallResult = 'none',
          },
        },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Disable',
          keywordSnippet = 'Disable',
        },
      },
    },
  },
  htmx = {
    filetypes = {
      'gohtml',
      'gohtmltmpl',
      'handlebars',
      'html',
      'mustache',
      'templ',
    },
  },
  -- WARN: You need to have `openssl-devel` to install asm_lsp
  asm_lsp = {
    single_file_support = true,
  },
  clangd = {},
  tinymist = {
    settings = {
      formatterMode = 'typstyle',
      exportPdf = 'onType',
      semanticTokens = 'disable',
    },
  },
  kotlin_lsp = {
    cmd_env = {
      JAVA_HOME = java_home_for_lsp,
    },
  },
  qmlls = {},
  jdtls = {
    handlers = {
      -- By assigning an empty function, you can remove the notifications
      -- printed to the cmd
      ['$/progress'] = function() end,
    },
  },
}

-- Make sure all LSPs and mason tools are installed
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'ruff',
  'stylua', -- Used to format Lua code
  'bash-language-server',
  'html-lsp',
  'htmx-lsp',
  'css-lsp',
  'json-lsp',
  'jq',
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }
vim.cmd.MasonToolsInstall()

-- Configure LSP servers
for server, config in pairs(servers) do
  if not vim.tbl_isempty(config) then
    vim.lsp.config(server, config)
  end
end

-- Enable LSP servers
require('mason-lspconfig').setup { automatic_enable = true }
