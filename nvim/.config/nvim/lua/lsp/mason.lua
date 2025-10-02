return {
  --==========================[ MASON INSTALLER ]==========================--
  {
    'williamboman/mason.nvim',
    opts = {
      ui = {
        border = 'rounded',
        icons = {
          package_installed = ' ',
          package_pending = ' ',
          package_uninstalled = ' ',
        },
      },
      -- you can keep your custom registries if you need them
      registries = {
        'github:mason-org/mason-registry',
        'github:Crashdummyy/mason-registry',
      },
    },
  },

  --======================[ MASON ↔ LSP (native API) ]=====================--
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
    },
    opts = {
      ensure_installed = {
        -- General
        'lua_ls',
        'jsonls',
        'html',
        'cssls',
        'eslint',
        'gopls',
        -- TypeScript (new id is ts_ls; we’ll alias to tsserver if needed)
        'ts_ls',
        -- Python
        'pyright',
        'ruff',
      },
      -- New flow: mason-lspconfig will auto-enable any server we define via vim.lsp.config()
      automatic_enable = true,
    },
    config = function(_, opts)
      local mlsp = require 'mason-lspconfig'
      mlsp.setup(opts)

      -- nvim-cmp capabilities (auto-imports, snippets, richer items)
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Helper to define server configs (works with Neovim 0.11+)
      local function define(server, cfg)
        -- Handle ts_ls -> tsserver fallback if your lspconfig uses the old name
        if server == 'ts_ls' then
          local ok = pcall(require, 'lspconfig.configs.ts_ls')
          if not ok then
            server = 'tsserver'
          end
        end

        vim.lsp.config(
          server,
          vim.tbl_deep_extend('force', {
            capabilities = capabilities,
          }, cfg or {})
        )
      end

      -- ---------- Generic servers ----------
      for _, s in ipairs { 'lua_ls', 'jsonls', 'html', 'cssls', 'eslint', 'gopls', 'ts_ls' } do
        define(s, {})
      end

      -- ---------- Lua: make lua_ls happy with Neovim runtime (optional but nice)
      define('lua_ls', {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            diagnostics = { globals = { 'vim' } },
            telemetry = { enable = false },
          },
        },
      })

      -- ---------- Python: Ruff (new first-party server) ----------
      -- Fast linting, quick fixes, organize imports. Let Pyright own hover.
      define('ruff', {
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      })

      -- ---------- Python: Pyright ----------
      -- LSP features + auto-import suggestions
      define('pyright', {
        settings = {
          python = {
            analysis = {
              autoImportCompletions = true, -- ✨ auto-imports in completion
              diagnosticMode = 'workspace',
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              -- Add extraPaths only if you really have a custom src dir, e.g. "py"
              -- extraPaths = { 'py' },
            },
          },
        },
      })

      -- Drop Ruff diagnostics; keep code actions, formatting, etc.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('ruff_drop_diags', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == 'ruff' then
            -- Override the diagnostics handler for this client only
            client.handlers['textDocument/publishDiagnostics'] = function() end
          end
        end,
      })
    end,
  },
}
