-- Core TS setup (parsers, highlight, indent, incremental selection)
require 'plugins.treesitter.nvim-treesitter'

-- Extra parsers (like caddyfile)
require 'plugins.treesitter.parsers-extra'

-- Textobjects (af/if, motions, swaps)
require 'plugins.treesitter.textobjects'

-- Context window at top of buffer
require 'plugins.treesitter.context'

-- Split/join structures
require 'plugins.treesitter.treesj'

-- Playground (optional)
-- require("plugins.treesitter.playground")

-- Query overrides (optional)
-- require("plugins.treesitter.queries-overrides")
