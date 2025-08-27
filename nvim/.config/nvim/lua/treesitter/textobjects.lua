return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-treesitter.configs').setup {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          include_surrounding_whitespace = false,
          keymaps = {
            ['if'] = '@function.inner',
            ['af'] = '@function.outer',
            ['im'] = '@function.inner',
            ['am'] = '@function.outer',
            ['ic'] = '@class.inner',
            ['ac'] = '@class.outer',
            -- add your assignment/loop/conditional maps here if you like
          },
          selection_modes = {
            ['@function.outer'] = 'V',
            ['@class.outer'] = 'V',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
        },
        swap = {
          enable = true,
          swap_next = { ['<leader>na'] = '@parameter.inner' },
          swap_previous = { ['<leader>pa'] = '@parameter.inner' },
        },
      },
    }

    -- Optional: repeat last TS movement with ; and ,
    local ok, rm = pcall(require, 'nvim-treesitter.textobjects.repeatable_move')
    if ok then
      vim.keymap.set({ 'n', 'x', 'o' }, ';', rm.repeat_last_move)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', rm.repeat_last_move_opposite)
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', rm.builtin_f_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', rm.builtin_F_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 't', rm.builtin_t_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', rm.builtin_T_expr, { expr = true })
    end
  end,
}
