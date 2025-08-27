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
      require('mason-lspconfig').setup {
        ensure_installed = {
          'lua_ls',
          'ts_ls',
          'eslint',
          'jsonls',
          'html',
          'cssls',
          'gopls',
        },
        automatic_enable = true,
      }

      -- local custom_lsp_configs = {
      --   -- LUA LANGUAGE SERVER
      --   lua_ls = {
      --     settings = {
      --       Lua = {
      --         diagnostics = { globals = { 'vim', 'require' } },
      --         workspace = {
      --           library = vim.api.nvim_get_runtime_file('', true),
      --           checkThirdParty = false,
      --         },
      --         telemetry = { enable = false },
      --       },
      --     },
      --   },
      -- }
      --
      -- require('mason-lspconfig').setup_handlers {
      --   function(server_name)
      --     if custom_lsp_configs[server_name] then
      --       -- APPLY CUSTOM CONFIG IF EXISTS
      --       local config = custom_lsp_configs[server_name]
      --       config.capabilities = capabilities
      --       require('lspconfig')[server_name].setup(config)
      --     else
      --       -- OTHER LANGUAGE SERVER AUTO CONFIG
      --       require('lspconfig')[server_name].setup {
      --         capabilities = capabilities,
      --       }
      --     end
      --   end,
      -- }

      require('lspconfig').harper_ls.setup {}
    end,
  },
}
