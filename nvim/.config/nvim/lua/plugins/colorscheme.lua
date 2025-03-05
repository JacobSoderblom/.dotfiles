return {
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin-mocha'

      require('catppuccin').setup {
        integrations = {
          neotree = true,
          mason = true,
          fidget = true,
          dap_ui = true,
        },
        transparent_background = true,
      }
    end,
  },
  {
    'f-person/auto-dark-mode.nvim',
    opts = {
      update_interval = 1000,
      default = 'dark',
      set_dark_mode = function()
        vim.api.nvim_set_option_value('background', 'dark', {})
        vim.cmd 'colorscheme catppuccin-mocha'
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value('background', 'light', {})
        vim.cmd 'colorscheme catppuccin-latte'
      end,
    },
  },
}
