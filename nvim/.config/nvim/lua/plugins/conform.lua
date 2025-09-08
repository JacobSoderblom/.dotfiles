return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true } -- <-- fix
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,

    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 2000,
          lsp_format = 'fallback',
        }
      end
    end,

    formatters_by_ft = {
      lua = { 'stylua' },
      cs = { 'csharpier_any' }, -- use the robust wrapper
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      python = { 'ruff_format' },
    },

    formatters = {
      csharpier_any = {
        -- Use a temp file; CSharpier will rewrite it, Conform copies it back.
        stdin = false,
        tempfile_postfix = '.cs',

        command = function()
          if vim.fn.executable 'csharpier' == 1 then
            return 'csharpier' -- global tool available
          end
          return 'dotnet' -- fall back to local tool
        end,

        args = function(_, ctx)
          if vim.fn.executable 'csharpier' == 1 then
            return { 'format', '$FILENAME' } -- no 'format', no '--write-stdout'
          end
          return { 'tool', 'run', 'csharpier', 'format', '$FILENAME' }
        end,

        cwd = function(_, ctx)
          -- project root so 'dotnet tool run' resolves local tools
          return vim.fs.root(ctx.filename, {
            '.config/dotnet-tools.json',
            'dotnet-tools.json',
            '.git',
            'Directory.Build.props',
            'Directory.Build.targets',
          }) or vim.loop.cwd()
        end,
      },
    },
  },
}
