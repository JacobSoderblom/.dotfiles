return {
  {
    'mistweaverco/kulala.nvim',
    opts = {},
    config = function()
      -- Key bindings for kulala.nvim with 'k' prefix
      local builtin = require 'kulala'

      -- Map <leader>kr to run the HTTP request
      vim.keymap.set('n', '<leader>kr', function()
        builtin.run()
      end, { desc = '[K]ulala [R]un the request' })

      -- Map <leader>kn to jump to the next HTTP request in the buffer
      vim.keymap.set('n', '<leader>kn', function()
        builtin.jump_next()
      end, { desc = '[K]ulala [N]ext request' })

      -- Map <leader>kb to jump to the previous HTTP request in the buffer
      vim.keymap.set('n', '<leader>kb', function()
        builtin.jump_prev()
      end, { desc = '[K]ulala [B]ack to previous request' })

      -- Map <leader>ki to inspect the current HTTP request
      vim.keymap.set('n', '<leader>ki', function()
        require('kulala').inspect()
      end, { noremap = true, silent = true, desc = '[K]ulala [I]nspect the current request' })

      -- Map <leader>kt to toggle between body and headers
      vim.keymap.set('n', '<leader>kt', function()
        require('kulala').toggle_view()
      end, { noremap = true, silent = true, desc = '[K]ulala [T]oggle between body and headers' })

      -- Map <leader>kco to copy the current request as a curl command
      vim.keymap.set('n', '<leader>kco', function()
        require('kulala').copy()
      end, { noremap = true, silent = true, desc = '[K]ulala [C]opy as c[O]mmand' })

      -- Map <leader>kci to insert from a curl command in the clipboard
      vim.keymap.set('n', '<leader>kci', function()
        require('kulala').from_curl()
      end, { noremap = true, silent = true, desc = '[K]ulala Insert from curl ([C]url [I]n)' })
    end,
  },
}
