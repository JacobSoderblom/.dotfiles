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
      cs = { 'csharpier_any' }, -- robust wrapper
      javascript = { 'biome', 'prettier' },
      javascriptreact = { 'biome', 'prettier' },
      typescript = { 'biome', 'prettier' },
      typescriptreact = { 'biome', 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      python = { 'ruff_format' },
    },

    formatters = {
      biome = {
        command = 'biome',
        args = { 'format', '--write', '--stdin-file-path', '$FILENAME' },
        stdin = true,
        -- optional: only run biome if a biome.json exists in the project
        condition = function(ctx)
          return vim.fs.find('biome.json', { upward = true, path = ctx.dirname })[1] ~= nil
        end,
      },
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
