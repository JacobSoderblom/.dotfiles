return {
  {
    'projekt0n/github-nvim-theme',
    priority = 1000,

    opts = {
      theme_style = 'dark_high_contrast',
      transparent = true,
    },

    config = function(_, opts)
      require('github-theme').setup(opts)
      vim.cmd.colorscheme 'github_dark_high_contrast'
    end,
  },
}
