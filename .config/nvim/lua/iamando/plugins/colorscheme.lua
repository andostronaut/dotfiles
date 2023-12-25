return {
  {
    "nyoom-engineering/oxocarbon.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.g.material_style = "dark"
      vim.cmd([[colorscheme oxocarbon]])

      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  }
}
