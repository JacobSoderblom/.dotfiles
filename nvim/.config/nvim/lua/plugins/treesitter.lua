return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local config = require 'nvim-treesitter.configs'
      config.setup {
        ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'typescript' },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },
}
