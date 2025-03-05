_G.get_oil_winbar = function()
  local dir = require('oil').get_current_dir()
  if dir then
    return vim.fn.fnamemodify(dir, ':~')
  else
    return vim.api.nvim_buf_get_name(0)
  end
end

return {
  'stevearc/oil.nvim',
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  config = function()
    local oil = require 'oil'
    local detail = false
    oil.setup {
      win_options = {
        winbar = '%{%v:lua.get_oil_winbar()%}',
      },
      default_file_explorer = true,
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
