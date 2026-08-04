local servers = require "configs.servers"

return {
  -- lsp, formatting, linting -------------------------------------------------

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- NvChad ships mason with PATH = "skip", which leaves mason's bin dir off
  -- Neovim's PATH and makes conform and nvim-lint unable to find anything
  -- mason installed
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.PATH = "prepend"
      return opts
    end,
  },

  -- mason.nvim itself ships with NvChad. These two companions drive
  -- installation from the lists in configs/servers.lua, and both depend on
  -- mason so lazy sets it up first, mason.setup() has to run before theirs.
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = servers.lsp,
      -- servers are enabled explicitly in configs/lspconfig.lua so the
      -- per-server overrides are guaranteed to be registered first
      automatic_enable = false,
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = servers.tools,
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },

  {
    "linrongbin16/lsp-progress.nvim",
    event = "LspAttach",
    opts = {},
  },

  {
    "folke/neoconf.nvim",
    cmd = "Neoconf",
    config = true,
  },

  -- languages ----------------------------------------------------------------

  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    -- no build step, run :GoInstallBinaries yourself when you want the Go tools
    opts = {},
  },

  -- treesitter ---------------------------------------------------------------

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "astro",
        "bash",
        "cmake",
        "css",
        "dart",
        "dockerfile",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "graphql",
        "hcl",
        "html",
        "ini",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "nix",
        "php",
        "phpdoc",
        "prisma",
        "printf",
        "pug",
        "python",
        "regex",
        "requirements",
        "rust",
        "scss",
        "solidity",
        "sql",
        "ssh_config",
        "styled",
        "svelte",
        "templ",
        "terraform",
        "toml",
        "tsx",
        "twig",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "xml",
        "yaml",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require "configs.textobjects"
    end,
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- git ----------------------------------------------------------------------

  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
    cmd = { "Git", "GitBlame", "GitDiff", "GitDiffClose", "GitCreatePullRequest", "GitRevert", "GitRevertFile" },
    opts = {},
  },

  {
    "f-person/git-blame.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = { enabled = false }, -- toggle with :GitBlameToggle
  },

  {
    "rbong/vim-flog",
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = { "tpope/vim-fugitive" },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewRefresh", "DiffviewFileHistory" },
  },

  -- ui -----------------------------------------------------------------------

  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = { user_default_options = { names = false } },
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true, -- classic bottom cmdline for search
        command_palette = true, -- cmdline and popupmenu together
        long_message_to_split = true, -- long messages go to a split
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)
      vim.notify = require("noice").notify
    end,
  },

  -- sessions -----------------------------------------------------------------

  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      auto_restore = false,
      suppressed_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
    },
    keys = {
      { "<leader>wr", "<cmd>SessionRestore<cr>", desc = "Restore session for cwd" },
      { "<leader>ws", "<cmd>SessionSave<cr>", desc = "Save session for cwd" },
    },
  },
}
