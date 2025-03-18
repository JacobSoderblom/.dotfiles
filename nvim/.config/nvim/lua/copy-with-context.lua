if vim.g.loaded_copy_with_context then
  return
end
vim.g.loaded_copy_with_context = true

-- Default mappings
local mappings = vim.g.copy_with_context_mappings or {
  relative = '<leader>cy',
  absolute = '<leader>cY',
}

local function copy_with_context(absolute_path, is_visual)
  local start_line, end_line

  if is_visual then
    start_line = vim.fn.line("v")
    end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end

  else
    start_line = vim.fn.line('.')
    end_line = start_line
  end

  local lines = vim.fn.getline(start_line, end_line)
  local content = table.concat(lines, "\n")

  local line_nums = is_visual and string.format("%d-%d", start_line, end_line) or tostring(start_line)

  local file_path
  if absolute_path then
    file_path = vim.fn.expand('%:p')
  else
    file_path = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
  end

  local output = string.format("# %s:%s\n\n%s", file_path, line_nums, content)

  vim.fn.setreg('*', output)
  vim.fn.setreg('+', output)

  print('Copied ' .. (is_visual and 'selection' or 'line') .. ' with context')
end

-- Apply mappings
vim.keymap.set('n', mappings.relative, function()
  copy_with_context(false, false)
end, { silent = true, desc = "Yank with relative path context" })

vim.keymap.set('n', mappings.absolute, function()
  copy_with_context(true, false)
end, { silent = true, desc = "Yank with absolute path context"})

vim.keymap.set('x', mappings.relative, function()
  copy_with_context(false, true)
end, { silent = true, desc = "Yank selection with relative path context"})

vim.keymap.set('x', mappings.absolute, function()
  copy_with_context(true, true)
end, { silent = true,  desc = "Yank selection with aboslute path context"})

