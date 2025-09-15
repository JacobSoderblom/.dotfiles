return {
  --==========================[ MASON LSP MANAGER ]==========================--

  -- Manager for language servers, linters, formatters
  {
    'mason-org/mason.nvim',
    opts = {
      ui = {
        icons = {
          package_installed = ' ',
          package_pending = ' ',
          package_uninstalled = ' ',
        },
        border = 'rounded',
        keymaps = {
          toggle_server_expand = '<CR>',
          install_server = 'i',
          update_server = 'u',
          check_server_version = 'c',
          update_all_servers = 'U',
          check_outdated_servers = 'C',
          uninstall_server = 'X',
          cancel_installation = '<C-c>',
        },
      },
    },
  },

  --=====================[ MASON TOOLS AUTO INSTALLER ]=====================--

  -- {
  --   'WhoIsSethDaniel/mason-tool-installer.nvim',
  --   opts = {
  --     ensure_installed = {
  --       'bash-language-server', -- Bash LSP
  --       'lua-language-server', -- Lua LSP
  --       'harper-ls',
  --       'pyright', -- Python LSP
  --       'ruff', -- Python formatter & linter
  --       'ruff-lsp', -- Ruff LSP
  --       'debugpy', -- Python DAP
  --     },
  --   },
  -- },
  --
  --==========================[ MASON LSP CONFIG ]==========================--

  -- Configures Mason installed servers to LSPConfig
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = {},
      dependencies = {
        'neovim/nvim-lspconfig',
      },
    },

    -- Manually configure servers (no setup_handlers in this fork)
    config = function()
      require('mason').setup {
        registries = {
          'github:mason-org/mason-registry',
          'github:Crashdummyy/mason-registry',
        },
      }

      local mason_lspconfig = require 'mason-lspconfig'
      mason_lspconfig.setup {
        ensure_installed = {
          'lua_ls',
          'ts_ls',
          'eslint',
          'jsonls',
          'html',
          'cssls',
          'gopls',
          'pyright',
          'ruff',
        },
      }

      local lspconfig = require 'lspconfig'
      local util = require 'lspconfig.util'

      -----------------------------------------------------------------------
      -- Default setup for servers OTHER than pyright
      -----------------------------------------------------------------------
      local default_servers = {
        'lua_ls',
        'ts_ls',
        'eslint',
        'jsonls',
        'html',
        'cssls',
        'gopls',
        'ruff',
      }
      for _, server in ipairs(default_servers) do
        if lspconfig[server] then
          lspconfig[server].setup {}
        end
      end

      -----------------------------------------------------------------------
      -- PYRIGHT: run inside uv + correct root + monorepo paths
      -----------------------------------------------------------------------
      local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin/pyright-langserver'

      lspconfig.pyright.setup {
        -- 1) Start the language server inside your uv-managed environment
        cmd = { 'uv', 'run', mason_bin, '--stdio' },

        -- 2) Ensure the workspace root is the repo root
        root_dir = util.root_pattern('pyrightconfig.json', 'pyproject.toml', '.git'),

        -- 3) Also explicitly set the interpreter from the detected root
        before_init = function(_, config)
          local buf = vim.api.nvim_buf_get_name(0)
          local root = util.find_git_ancestor(buf) or util.root_pattern('pyrightconfig.json', 'pyproject.toml')(buf) or vim.loop.cwd()
          config.settings = config.settings or {}
          config.settings.python = config.settings.python or {}
          config.settings.python.pythonPath = root .. '/.venv/bin/python'
        end,

        settings = {
          python = {
            analysis = {
              diagnosticMode = 'workspace', -- analyze full workspace
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              -- Your repo sources live under "py/", expose that to the analyzer
              extraPaths = { 'py' },
            },
          },
        },
      }
    end,
  },
}
