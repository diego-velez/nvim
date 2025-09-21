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
  },
}

vim.g.was_setup = false
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('DVT LSP Config', { clear = true }),
  callback = function(event)
    if not vim.g.was_setup then
      require('debugprint').setup {

        keymaps = {
          normal = {
            plain_below = '',
            plain_above = '',
            variable_below = '',
            variable_above = '',
            variable_below_alwaysprompt = '',
            variable_above_alwaysprompt = '',
            surround_plain = '',
            surround_variable = '',
            surround_variable_alwaysprompt = '',
            textobj_below = '',
            textobj_above = '',
            textobj_surround = '',
            toggle_comment_debug_prints = '',
            delete_debug_prints = '',
          },
          insert = {
            plain = '',
            variable = '',
          },
          visual = {
            variable_below = '',
            variable_above = '',
          },
        },
        display_counter = false,
      }
      vim.g.was_setup = true
    end

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
    vim.keymap.set('n', 'K', '<nop>')

    if
      client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, event.buf)
    then
      vim.notify 'Codelens Supported'
      map('<leader>cc', vim.lsp.codelens.run, 'LSP: [C]odelens')
      map('<leader>cC', vim.lsp.codelens.refresh, 'LSP: Refresh [C]odelens')
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

    -- [H]ere aka we are *here* in the code
    map('g?h', function()
      require('debugprint').debugprint {}
    end, 'We are [h]ere (below)')
    map('g?H', function()
      require('debugprint').debugprint { above = true }
    end, 'We are [h]ere (above)')

    -- [V]ariable aka this is the value of said variable
    map('g?v', function()
      require('debugprint').debugprint { variable = true }
    end, 'This [v]ariable (below)')
    map('g?V', function()
      require('debugprint').debugprint { above = true, variable = true }
    end, 'This [v]ariable (above)')

    -- [P]rompt aka we want to see the value of user input variable
    map('g?p', function()
      require('debugprint').debugprint { variable = true, ignore_treesitter = true }
    end, '[P]rompt for variable (below)')
    map('g?P', function()
      require('debugprint').debugprint { above = true, variable = true, ignore_treesitter = true }
    end, '[P]rompt for variable (above)')

    -- Other operations
    map('g?d', function()
      require('debugprint.printtag_operations').deleteprints()
    end, '[D]elete all debugprint in current buffer')
    map('g?t', function()
      require('debugprint.printtag_operations').toggle_comment_debugprints()
    end, '[T]oggle debugprint statements')
    map('g?s', function()
      MiniPick.builtin.grep({ pattern = 'DEBUGPRINT:' }, nil)
    end, '[S]earch all debugprint statements')
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
}

-- Configure Java specific stuff separately
require('java').setup {}
require('lspconfig').jdtls.setup {
  handlers = {
    -- By assigning an empty function, you can remove the notifications
    -- printed to the cmd
    ['$/progress'] = function() end,
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
