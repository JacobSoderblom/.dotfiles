local picker       = true
local quickfile    = true
local statuscolumn = true
local notifier     = true
local bigfile      = false
local scroll       = false
local indent       = false
local dashboard    = false
local words        = false
local explorer     = false
-- Custom Functions
local sidebar      = false -- Open explorer on startup

local function toggle_terminal()
  if vim.bo.buftype == "terminal" then
    vim.cmd("hide")
  else
    Snacks.terminal.toggle("zsh")
  end
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,

  init = function()
    local function AutostartSidebar(something)
      if not something then return end
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          Snacks.explorer.open()
        end,
      })
    end
    AutostartSidebar(sidebar)
  end,

  keys = {
    -- 🗂️ General & Explorer
    { "<leader><space>", function() require("snacks").picker.smart() end,                desc = "Smart File Picker (Git-aware)" },
    { "<leader>,",       function() require("snacks").picker.buffers() end,             desc = "Open Buffers" },
    { "<leader>/",       function() require("snacks").picker.grep() end,                desc = "Live Grep in Project" },
    { "<leader>.",       function() require("snacks").picker.recent() end,              desc = "Recently Opened Files" },
    { "<leader>e",       function() require("snacks").explorer() end,                   desc = "Toggle File Explorer" },
    { "<leader>:",       function() require("snacks").picker.command_history() end,     desc = "Command History (:) Usage)" },
    { "<leader>n",       function() require("snacks").picker.notifications() end,       desc = "Notification History" },

    -- 🔍 File Finding
    { "<leader>ff",      function() require("snacks").picker.files() end,               desc = "Find Files (root dir)" },
    { "<leader>fg",      function() require("snacks").picker.git_files() end,           desc = "Find Git Tracked Files" },
    { "<leader>fb",      function() require("snacks").picker.buffers() end,             desc = "Find Open Buffers" },
    { "<leader>fp",      function() require("snacks").picker.projects() end,            desc = "Switch Projects (root dirs)" },

    -- 🔎 Grep/Search
    { "<leader>ss",      function() require("snacks").picker.grep() end,                desc = "Live Grep in Files" },
    { "<leader>sw",      function() require("snacks").picker.grep_word() end,           desc = "Find Word Under Cursor" },
    { "<leader>sb",      function() require("snacks").picker.lines() end,               desc = "Search Lines in Current Buffer" },
    { "<leader>sB",      function() require("snacks").picker.grep_buffers() end,        desc = "Search Across All Open Buffers" },
    { "<leader>su",      function() require("snacks").picker.undo() end,                desc = "Browse Undo History" },

    -- 🧠 LSP
    { "gd",              function() require("snacks").picker.lsp_definitions() end,      desc = "LSP: Go to Definition" },
    { "gD",              function() require("snacks").picker.lsp_declarations() end,     desc = "LSP: Go to Declaration" },
    { "gr",              function() require("snacks").picker.lsp_references() end,       desc = "LSP: Find References" },
    { "gI",              function() require("snacks").picker.lsp_implementations() end,  desc = "LSP: Go to Implementation" },
    { "gy",              function() require("snacks").picker.lsp_type_definitions() end, desc = "LSP: Go to Type Definition" },
    { "<leader>ls",      function() require("snacks").picker.lsp_symbols() end,          desc = "LSP: Document Symbols" },
    { "<leader>lS",      function() require("snacks").picker.lsp_workspace_symbols() end,desc = "LSP: Workspace Symbols" },

    -- 🧬 Git
    { "<leader>gg",      function() require("snacks").lazygit.open() end,               desc = "Open LazyGit" },
    { "<leader>gs",      function() require("snacks").picker.git_status() end,          desc = "Git Status (Files Changed)" },
    { "<leader>gl",      function() require("snacks").picker.git_log() end,             desc = "Git Commit Log" },
    { "<leader>gb",      function() require("snacks").picker.git_branches() end,        desc = "Git Branches" },
    { "<leader>gd",      function() require("snacks").picker.git_diff() end,            desc = "Git Diff (Hunks View)" },

    -- 📦 Buffers
    { "<leader>bd",      function() require("snacks").bufdelete.delete() end,           desc = "Close Current Buffer" },
    { "<leader>bD",      function() require("snacks").bufdelete.all() end,              desc = "Close All Buffers" },

    -- ✨ Word References
    { "]]",              function() require("snacks").words.jump(vim.v.count1) end,     desc = "Next Symbol Usage (LSP Words)" },
    { "[[",              function() require("snacks").words.jump(-vim.v.count1) end,    desc = "Prev Symbol Usage (LSP Words)" },
    {
      "<leader>uw",
      function()
        local w = require("snacks").words
        if w.is_enabled() then
          w.disable()
        else
          w.enable()
        end
      end,
      desc = "Toggle LSP Symbol Highlighting",
    },

    -- 🖥️ Terminal
    { "<M-/>", toggle_terminal, desc = "Toggle Terminal", mode = { "n", "t" } },
    { "<M-_>", toggle_terminal, desc = "Toggle Terminal (TMUX)", mode = { "n", "t" } },
  },


  opts = {
    -- input = { enabled = input },
    -- scope = { enabled = scope },


    -- █▀█ █ █▀▀ █▄▀ █▀▀ █▀█
    -- █▀▀ █ █▄▄ █░█ ██▄ █▀▄

    -- Positives
    -- 1. Hell lotta stuff bro
    -- 2. Wayyy better token highlighting than telescope

    picker = {
      enabled = picker,
      focus = "input", --"input"|"list" (defaults to "input")
      win = {
        input = {
          keys = {
            ["x"] = "close",
          }
        },
        list = {
          keys = {
            ["x"] = "close",
          }
        }
      },
      sources = {

        -- █▀▀ ▀▄▀ █▀█ █░░ █▀█ █▀█ █▀▀ █▀█
        -- ██▄ █░█ █▀▀ █▄▄ █▄█ █▀▄ ██▄ █▀▄

        -- Positives
        -- 1. Acts as a side bar file picker with fuzzy finding
        -- 2. Shows LSP diagnostics for all files in the project
        -- 3. Shows Git status for all files in the project

        explorer = {
          enabled = explorer,
          focus = true,
          hidden = true,
          layout = {
            layout = {
              -- width = 0.2,       -- fixed percentage width
              position = "left", -- default "left"
            },
            hidden = { "input" },
            auto_hide = { "input" },
          }
        },
      },

      ---@class snacks.picker.icons
      icons = {
        tree = {
          vertical = "│ ",
          middle   = "├╴",
          last     = "╰╴",
        },
        git = {
          staged    = "",
          modified  = "",
          renamed   = "",
          untracked = "?",
        },
      },
    },


    -- █▀ ▀█▀ ▄▀█ ▀█▀ █░█ █▀ █▀▀ █▀█ █░░ █░█ █▀▄▀█ █▄░█
    -- ▄█ ░█░ █▀█ ░█░ █▄█ ▄█ █▄▄ █▄█ █▄▄ █▄█ █░▀░█ █░▀█

    -- Negatives
    -- 1. Adds one more column after numberline which adds slight bulk

    -- Positives
    -- 1. Solves the issue of not showing git signs and LSP diagnostics at the same time
    -- 2. Even though it adds one more column, it's pretty neat tho.

    statuscolumn = {
      enabled = statuscolumn,
      left = { "mark", "sign" }, -- priority of signs on the left
      right = { "fold", "git" }, -- priority of signs on the right
      folds = {
        open = false,            -- show open fold icons
        git_hl = true,           -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { "GitSign", "MiniDiffSign" },
      },
      refresh = 100, -- refresh at most every 50ms
    },


    -- █ █▄░█ █▀▄ █▀▀ █▄░█ ▀█▀
    -- █ █░▀█ █▄▀ ██▄ █░▀█ ░█░

    -- Negatives
    -- 1. Scope using Treesitter doesn't work
    -- 2. Default indent opts.indent.char doesn't work
    -- 3. indent-blankline have full scope outlining

    -- Positives
    -- 1. Breezy Animations
    -- 2. Sits well with rainbow brackets

    -- Conclusion: Use indent-blankline for now

    indent = {
      priority = 1,
      enabled = indent,
      char = "│",
      scope = {
        enabled = true, -- enable highlighting the current scope
        priority = 200,
        char = "│", -- ▎ ▍ │
        underline = false, -- underline the start of the scope
        only_scope = false, -- only show indent guides of the scope
        hl = {
          "RainbowBracket1",
          "RainbowBracket2",
          "RainbowBracket3",
          "RainbowBracket4",
        },
      },
      animate = {
        enabled = vim.fn.has("nvim-0.10") == 1,
        style = "out", -- "out"|"up_down"|"down"|"up"
        easing = "linear",
        duration = {
          step = 20,   -- ms per step
          total = 400, -- maximum duration
        },
      },
    },


    -- █▀▄ ▄▀█ █▀ █░█ █▄▄ █▀█ ▄▀█ █▀█ █▀▄
    -- █▄▀ █▀█ ▄█ █▀█ █▄█ █▄█ █▀█ █▀▄ █▄▀

    -- Negatives
    -- 1. Not that customizable.. (single line key section)

    -- Positives
    -- 1. Advanced multi panel layout
    -- 2. Responsive UI

    -- Conclusion: Use dashboard-nvim for now

    dashboard = {
      enabled = dashboard,
      sections = {
        { section = "header" },
        { section = "keys",  gap = 0, padding = 1 },
        {
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          indent = 3,
          padding = { 2, 0 },
        },
        { section = "startup" },
      },
    },


    -- █▀ █▀▀ █▀█ █▀█ █░░ █░░
    -- ▄█ █▄▄ █▀▄ █▄█ █▄▄ █▄▄

    -- Negatives
    -- 1. Not fast enough for my workflow even after lowering numbers drastically

    scroll = {
      enabled = scroll,
      animate = {
        duration = { step = 2, total = 20 },
        easing = "linear",
      },
      animate_repeat = {
        duration = { step = 1, total = 10 },
        easing = "linear",
      },
      -- Prevents activation on terminal
      -- Prevents activation until half page jump and next half page jump
      filter = function(buf)
        local cursor_line = vim.fn.line(".")
        local half_page = vim.fn.winheight(0) / 2
        local half_jump = half_page / 2
        local disabled_lines = half_page + half_jump - 1
        return vim.g.snacks_scroll ~= false
            and vim.b[buf].snacks_scroll ~= false
            and vim.bo[buf].buftype ~= "terminal"
            and cursor_line > disabled_lines
      end,
    },


    -- █▄▄ █ █▀▀ █▀▀ █ █░░ █▀▀
    -- █▄█ █ █▄█ █▀░ █ █▄▄ ██▄

    -- Negatives
    -- 1. Premature so, no out of the box configs like faster.nvim/bigfile.nvim

    bigfile = {
      enabled = bigfile,
      notify = true,
      size = 1 * 1024 * 1024, -- 1MB
      line_length = 3000,
      ---@param ctx {buf: number, ft:string}
      setup = function(ctx)
        -- matchparen
        if vim.fn.exists(":NoMatchParen") ~= 0 then
          vim.cmd([[NoMatchParen]])
        end
        -- lsp
        if vim.fn.exists(":LspStop") ~= 0 then
          vim.cmd([[LspStop]])
        end
        -- treesitter
        if vim.fn.exists(":TSBufDisable") ~= 0 then
          vim.cmd([[TSBufDisable all]])
        end
        -- syntax
        vim.cmd "syntax clear"
        vim.opt_local.syntax = "OFF"
        -- filetype
        vim.opt_local.filetype = ""
        -- winopts
        Snacks.util.wo(0, {
          swapfile = false,
          foldmethod = "manual",
          statuscolumn = "",
          conceallevel = 0,
          undolevels = -1,
          undoreload = 0,
          list = false
        })
        vim.b.minianimate_disable = true
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ctx.buf) then
            vim.bo[ctx.buf].syntax = ctx.ft
          end
        end)
      end,
    },


    -- █▀█ █░█ █ █▀▀ █▄▀ █▀▀ █ █░░ █▀▀
    -- ▀▀█ █▄█ █ █▄▄ █░█ █▀░ █ █▄▄ ██▄

    -- Positives
    -- 1. Fastest File in the West
    -- 2. Quickly loads file before loading plugins

    quickfile = {
      enabled = quickfile,
      exclude = { "latex" },
    },


    -- ▀█▀ █▀▀ █▀█ █▀▄▀█ █ █▄░█ ▄▀█ █░░
    -- ░█░ ██▄ █▀▄ █░▀░█ █ █░▀█ █▀█ █▄▄

    terminal = {
      win = {
        border = "rounded", -- single | rounded | double | solid | shadow | none
        resize = true,
        position = "float", -- "bottom"|"float"|"left"|"right"|"top"
      }
    },


    -- █░░ ▄▀█ ▀█ █▄█ █▀▀ █ ▀█▀
    -- █▄▄ █▀█ █▄ ░█░ █▄█ █ ░█░

    lazygit = {
      configure = false, -- apply colorscheme to lazygit
      win = {
        border = "rounded",
        width = 0,
        height = 0,
      },
    },


    -- █░█░█ █▀█ █▀█ █▀▄ █▀
    -- ▀▄▀▄▀ █▄█ █▀▄ █▄▀ ▄█

    words = {
      enabled = words,
      debounce = 100,  -- time in ms to wait before updating
      modes = { "n" }, -- default { "n", "i", "c" }
    },


    -- █▄░█ █▀█ ▀█▀ █ █▀▀ █▄█
    -- █░▀█ █▄█ ░█░ █ █▀░ ░█░

    -- Positives
    -- 1. Works best in tandem with Noice.nvim lsp messages on bottom

    notifier = {
      enabled = notifier,
      timeout = 3000,    -- default timeout in ms
      ---@type snacks.notifier.style
      style = "minimal", -- minimal | compact | fancy
      top_down = true,   -- place notifications from top to bottom
      refresh = 100,     -- default 50
    },
  },
}
