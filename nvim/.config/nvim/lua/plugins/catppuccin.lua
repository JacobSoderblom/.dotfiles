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
      }
    end,
  },
}
