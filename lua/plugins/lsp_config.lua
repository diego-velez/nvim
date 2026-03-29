-- vim.lsp.set_log_level 'off' WARN: this might be needed if getting lsp log too big ah type shi

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

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('DVT LSP Config', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
    end
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    map('gd', function()
      MiniPick.registry.LspPicker('definition', true)
    end, 'LSP: [G]oto [D]efinition')

    map('gr', function()
      MiniPick.registry.LspPicker('references', true)
    end, 'LSP: [G]oto [R]eferences')

    map('gI', function()
      MiniPick.registry.LspPicker('implementation', true)
    end, 'LSP: [G]oto [I]mplementation')

    map('gy', function()
      MiniPick.registry.LspPicker('type_definition', true)
    end, 'LSP: [G]oto T[y]pe Definition')

    map('gD', function()
      MiniPick.registry.LspPicker('declaration', true)
    end, 'LSP: [G]oto [D]eclaration')

    map('<leader>ca', vim.lsp.buf.code_action, 'LSP: Code [A]ction')

    map('<leader>cr', function()
      require('live-rename').rename { insert = true }
    end, 'LSP: [R]ename')

    map('h', vim.lsp.buf.hover, 'LSP: [H]over')
    vim.keymap.set('n', 'K', '<nop>', { buf = event.buf })

    if
      client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, event.buf)
    then
      vim.notify 'Codelens Supported'
      map('<leader>cc', vim.lsp.codelens.run, 'LSP: [C]odelens')
      map('<leader>tC', function()
        vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())

        if vim.lsp.codelens.is_enabled() then
          vim.notify('Codelens enabled', vim.log.levels.INFO)
        else
          vim.notify('Codelens disabled', vim.log.levels.INFO)
        end
      end, 'LSP: [T]oggle [C]odelens')
    end

    if
      client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
    then
      vim.notify 'Inlay Hints Supported'
      map('<leader>ti', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })

        if vim.lsp.inlay_hint.is_enabled { bufnr = event.buf } then
          vim.notify('Inlay hints enabled', vim.log.levels.INFO)
        else
          vim.notify('Inlay hints disabled', vim.log.levels.INFO)
        end
      end, 'LSP: [T]oggle [I]nlay Hints')
    end
  end,
})

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
