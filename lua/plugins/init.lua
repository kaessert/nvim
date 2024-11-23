return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "karb94/neoscroll.nvim",
    lazy = false,
    config = function ()
      require('neoscroll').setup {}
    end
  },
  {
    "jjo/vim-cue",
  },
  {
    "pocco81/auto-save.nvim",
    lazy = false
  },
  {
    "hashivim/vim-terraform",
    ft = "terraform"
  },
  {
    "kylechui/nvim-surround",
    lazy = false,
    config = function()
      require("nvim-surround").setup({})
    end
  },
  {
    "kcl-lang/kcl.nvim",
    config = function()
      require('lazy').setup({})
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function ()
      require "configs.nvim-tree"
    end
  },
  {
    "hrsh7th/nvim-cmp",
    opts = {
        sources = {
            { name = 'nvim_lsp' },
            { name = 'path' },
        },
    }
  },
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
