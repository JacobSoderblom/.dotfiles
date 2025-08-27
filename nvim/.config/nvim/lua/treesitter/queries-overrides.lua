return {
  dir = vim.fn.stdpath 'config' .. '/queries', -- no-op, just documents location
  name = 'treesitter-queries-overrides',
  lazy = true,
}
