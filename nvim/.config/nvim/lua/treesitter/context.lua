return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'VeryLazy',
  config = function()
    vim.cmd [[highlight TreesitterContextBottom guisp=#45475a]]
    require('treesitter-context').setup {
      enable = true,
      max_lines = 5,
      multiline_threshold = 1,
      mode = 'cursor',
      separator = nil,
    }
  end,
}
