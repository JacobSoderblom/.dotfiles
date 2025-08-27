return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPre', 'BufNewFile' },
  build = ':TSUpdate',
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'css',
      'gitignore',
      'html',
      'javascript',
      'json',
      'jsonc',
      'lua',
      'markdown',
      'markdown_inline',
      'python',
      'query',
      'regex',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
      'rust',
    },
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true, disable = { 'yaml', 'dart' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-k>',
        node_incremental = '<C-k>',
        node_decremental = '<C-j>',
        scope_incremental = '<C-h>',
      },
    },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
}
