local function add_dotnet_mappings()
  local dotnet = require 'easy-dotnet'

  vim.api.nvim_create_user_command('Secrets', function()
    dotnet.secrets()
  end, {})

  vim.keymap.set('n', '<C-t>', function()
    vim.cmd 'Dotnet testrunner'
  end, { nowait = true })

  vim.keymap.set('n', '<C-p>', function()
    dotnet.run_with_profile(true)
  end, { nowait = true })

  vim.keymap.set('n', '<C-b>', function()
    dotnet.build_default_quickfix()
  end, { nowait = true })
end

-- lazy.nvim
return {
  {
    'seblj/roslyn.nvim',
    ft = 'cs',
    config = function()
      require('roslyn').setup {
        config = {
          settings = {
            ['csharp|background_analysis'] = {
              dotnet_compiler_diagnostics_scope = 'fullSolution',
            },
            ['csharp|inlay_hints'] = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
              csharp_enable_inlay_hints_for_implicit_variable_types = true,
              csharp_enable_inlay_hints_for_lambda_parameter_types = true,
              csharp_enable_inlay_hints_for_types = true,
              dotnet_enable_inlay_hints_for_indexer_parameters = true,
              dotnet_enable_inlay_hints_for_literal_parameters = true,
              dotnet_enable_inlay_hints_for_object_creation_parameters = true,
              dotnet_enable_inlay_hints_for_other_parameters = true,
              dotnet_enable_inlay_hints_for_parameters = true,
              dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
            ['csharp|code_lens'] = {
              dotnet_enable_references_code_lens = true,
            },
          },
        },
        filewatching = not vim.g.is_perf,
      }
    end,
  },
  {
    'GustavEikaas/easy-dotnet.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
      local dotnet = require 'easy-dotnet'
      dotnet.setup {
        test_runner = {
          enable_buffer_test_execution = true,
          viewmode = 'float',
        },
        auto_bootstrap_namespace = true,
        terminal = function(path, action, args)
          local commands = {
            run = function()
              return string.format('dotnet run --project %s %s', path, args)
            end,
            test = function()
              return string.format('dotnet test %s %s', path, args)
            end,
            restore = function()
              return string.format('dotnet restore %s %s', path, args)
            end,
            build = function()
              return string.format('dotnet build %s %s', path, args)
            end,
          }

          local command = commands[action]() .. '\r'
          require('toggleterm').exec(command, nil, nil, nil, 'float')
        end,
      }

      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          if dotnet.is_dotnet_project() then
            add_dotnet_mappings()
          end
        end,
      })
    end,
  },
}
