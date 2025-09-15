return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
      'github/copilot.vim',
    },
    build = 'make tiktoken',
    opts = {
      model = 'gpt-5-mini', -- AI model to us
      temperature = 0.1, -- Lower = focused, higher = creative
      window = {
        layout = 'vertical', -- 'vertical', 'horizontal', 'float'
        width = 0.5, -- 50% of screen width
      },
      auto_insert_mode = true, -- Enter insert mode when opening
    },
    config = function(_, opts)
      require('CopilotChat').setup(opts)

      -- 🔌 Disable GitHub Copilot inline completions (intellisense/ghost text)
      vim.g.copilot_enabled = 0
    end,
  },
}
