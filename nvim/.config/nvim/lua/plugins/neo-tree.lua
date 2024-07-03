-- lua/plugins/neo-tree.lua
local kickstart_neo_tree = require 'kickstart.plugins.neo-tree'

-- Extend the configuration
kickstart_neo_tree.keys = {
  { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  { '<C-n>', ':Neotree filesystem reveal left<CR>', { noremap = true, silent = true, desc = 'NeoTree reveal left' } },
  { '<leader>bf', ':Neotree buffers reveal float<CR>', { noremap = true, silent = true, desc = 'NeoTree buffers float' } },
}

kickstart_neo_tree.config = function()
  -- Default configuration from kickstart
  require('neo-tree').setup(kickstart_neo_tree.opts)
end

return kickstart_neo_tree
