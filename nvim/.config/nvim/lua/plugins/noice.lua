return {
  'folke/noice.nvim',
  event = 'VeryLazy',

  -- runs before Noice registers its handlers/autocmds
  init = function()
    local orig = vim.lsp.handlers['$/progress']
    vim.lsp.handlers['$/progress'] = function(err, params, ctx, cfg)
      -- some servers (or launchers) emit malformed progress without `token`
      if not params or params.token == nil then
        return
      end
      return orig and orig(err, params, ctx, cfg)
    end
  end,

  opts = {
    -- keep the rest of your config as-is
    presets = { bottom_search = false, command_palette = true, long_message_to_split = false, lsp_doc_border = true, inc_rename = true },
    cmdline = {
      enabled = true,
      view = 'cmdline_popup',
      format = {
        cmdline = { icon = '' },
        search_down = { icon = ' ' },
        search_up = { icon = ' ' },
        filter = { icon = '$' },
        lua = { icon = '' },
        help = { icon = '' },
      },
    },
    messages = { enabled = true, view = 'notify', view_error = 'notify', view_warn = 'notify', view_history = 'messages', view_search = 'virtualtext' },
    popupmenu = { enabled = false, backend = 'nui' },
    lsp = {
      progress = {
        enabled = true, -- you can keep it on now
        format = 'lsp_progress',
        format_done = 'lsp_progress_done',
        throttle = 1000 / 30,
        view = 'mini',
      },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      message = { enabled = false, view = 'notify', opts = {} },
    },
    health = { checker = false },
    routes = {
      { view = 'notify', filter = { event = 'msg_showmode', find = 'recording' } },
    },
  },

  dependencies = { 'MunifTanjim/nui.nvim' },
}
