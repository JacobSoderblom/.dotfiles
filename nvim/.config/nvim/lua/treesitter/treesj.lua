return {
  'Wansmer/treesj',
  keys = {
    { '<leader>j', '<cmd>TSJToggle<cr>', desc = 'TreeSJ Toggle Split/Join' },
    { '<leader>J', "<cmd>lua require('treesj').join()<cr>", desc = 'TreeSJ Join' },
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesj').setup {
      use_default_keymaps = false,
      cursor_behavior = 'hold',
      notify = true,
      dot_repeat = true,
    }
  end,
}
