--===========================[ @GENERAL_COMMANDS ]===========================--
-- Use system clipboard
vim.opt.clipboard = 'unnamedplus'

-- Highlighted Yank
vim.cmd [[
au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
]]

-- Scroll past last line
vim.cmd [[nnoremap <expr> j line(".") == line('$') ? '<C-e>':'j']]

-- Automatically change number based on Insert Mode
vim.cmd [[autocmd InsertEnter * :set norelativenumber]]
vim.cmd [[autocmd InsertLeave * :set relativenumber]]
