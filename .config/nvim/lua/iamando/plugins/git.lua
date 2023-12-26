return {  
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },

  {
    "f-person/git-blame.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local git_blame = require("gitblame")

      git_blame.is_blame_text_available() -- Returns a boolean value indicating whether blame message is available
      git_blame.get_current_blame_text() --  Returns a string with blame message
    end,
  },

  {
    "rbong/vim-flog",
    lazy = true,
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = {
      "tpope/vim-fugitive",
    },
  },

  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  }
}