return {
  'stevearc/oil.nvim',
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  config = function()
    local oil = require 'oil'
    local detail = false
    oil.setup {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      columns = {
        'icon',
      },
      keymaps = {
        ['gd'] = {
          desc = 'Toggle file detail view',
          callback = function()
            detail = not detail
            if detail then
              require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
            else
              require('oil').set_columns { 'icon' }
            end
          end,
        },
      },
    }
    vim.keymap.set('n', '\\', oil.toggle_float, {})
    -- vim.keymap.set('n', '\\', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end,
}
