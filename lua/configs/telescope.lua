-- load defaults i.e lua_lsp
local telescope = require "telescope"

telescope.setup({
  defaults = {
    vimgrep_arguments = { 'rg', '--hidden', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' }
  },
  pickers = {
    find_files = {
      hidden = true,
      follow = true,
      file_ignore_patterns = { "^.git/" }
    }
  }
})
