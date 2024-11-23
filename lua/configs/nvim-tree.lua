-- load defaults i.e lua_lsp
local nvimtree = require "nvim-tree"

nvimtree.setup({
  git = {
    enable = false,  -- Completely disable git integration
  },
  update_focused_file = {
    enable = true,
    update_cwd = true
  }
})
