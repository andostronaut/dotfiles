return {
  {
    "marko-cerovac/material.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local material = require("material")

      material.setup({
        contrast = {
          sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
        },
        disable = {
          background = true,
        }
      })

      -- load the colorscheme here
      vim.g.material_style = "darker"
      vim.cmd([[colorscheme material]])
    end,
  },
}
