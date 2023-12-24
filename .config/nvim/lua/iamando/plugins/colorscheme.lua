return {
  {
    "marko-cerovac/material.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.g.material_style = "darker"
      vim.cmd([[colorscheme material]])
    end,
  },
}
