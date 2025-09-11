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

  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'bash-language-server', -- Bash LSP
        'lua-language-server', -- Lua LSP
        'harper-ls',
        'pyright', -- Python LSP
        'ruff', -- Python formatter & linter
        'ruff-lsp', -- Ruff LSP
        'debugpy', -- Python DAP
      },
    },
  },

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

    -- Automatically configures LSP servers
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
          'ruff_lsp',
        },
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          if server_name ~= 'pyright' then
            require('lspconfig')[server_name].setup {}
          end
        end,
      }

      require('lspconfig').harper_ls.setup {}
    end,
  },
}
