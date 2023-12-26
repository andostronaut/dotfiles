local options = {
  mason = {
    ensure_installed = {
      "lua-language-server",
    }, -- not an option from mason.nvim
    PATH = "skip",
    ui = {
      icons = {
        package_pending = " ",
        package_installed = "󰄳 ",
        package_uninstalled = " 󰚌",
      },
      keymaps = {
        toggle_server_expand = "<CR>",
        install_server = "i",
        update_server = "u",
        check_server_version = "c",
        update_all_servers = "U",
        check_outdated_servers = "C",
        uninstall_server = "X",
        cancel_installation = "<C-c>",
      },
    },
    max_concurrent_installers = 10,
  },

  lspconfig = {
    ensure_installed = {
      "tsserver",
      "html",
      "cssls",
      "tailwindcss",
      "svelte",
      "lua_ls",
      "graphql",
      "emmet_ls",
      "prismals",
      "pyright",
      "angularls",
      "astro",
      "denols",
      "dockerls",
      "golangci_lint_ls",
      "helm_ls",
      "jsonls",
      "pylsp",
      "ruby_ls",
      "rust_analyzer",
      "terraformls",
      "volar",
      "bashls",
      "sqlls",
    },
    -- auto-install configured servers (with lspconfig)
    automatic_installation = true, -- not the same as ensure_installed
  },

  tool = {
    ensure_installed = {
      "prettier",
      "stylua",
      "isort",
      "black",
      "pylint",
      "eslint_d",
      "autopep8",
      "rubocop",
      "rubyfmt",
      "gofumpt",
      "goimports",
      "jsonlint",
      "tflint",
      "yamllint",
    },
  }
}

return options