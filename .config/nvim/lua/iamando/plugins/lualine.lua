return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "linrongbin16/lsp-progress.nvim" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = "oxocarbon",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          {
            "filename",
            file_status = true,
            path = 1,
            color = {
              bg = "#33186B"
            },
          },
          {
            "diagnostics",
            color = {
              bg = "#7360DF"
            },
          },
          {
            "branch",
            color = {
              bg = "#C499F3"
            },
          },
          {
            "diff",
            color = {
              bg = "#F2AFEF"
            },
          },
        },
        lualine_c = {
          require("lsp-progress").progress,
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = {
              bg = "#C499F3"
            },
          },
          {
            "encoding",
            color = {
              bg = "#7360DF"
            },
          },
          {
            "filetype",
            color = {
              bg = "#33186B"
            },
          },
        },
        lualine_y = {
          {
            "progress",
            color = {
              bg = "#C499F3"
            },
          }
        },
        lualine_z = {
          {
            "location",
            color = {
              bg = "#7360DF"
            },
          }
        },
      },
      inactive_sections = {
        lualine_a = {
          {
            "filename",
            file_status = true,
            path = 1,
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    })

    -- listen lsp-progress event and refresh lualine
    vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = "lualine_augroup",
      pattern = "LspProgressStatusUpdated",
      callback = require("lualine").refresh,
    })
  end,
}
