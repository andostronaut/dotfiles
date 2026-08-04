-- Single source of truth for tooling.
--
-- `lsp` holds lspconfig server names, which is what both mason-lspconfig and
-- vim.lsp.enable() expect. `tools` holds mason package names, which is a
-- different namespace. Keeping the two lists apart and in one file is what
-- stops them drifting out of sync.

local M = {}

-- installed by mason, enabled by lspconfig
M.lsp = {
  "angularls",
  "astro",
  "bashls",
  "cssls",
  "denols",
  "dockerls",
  "emmet_ls",
  "gopls",
  "graphql",
  "helm_ls",
  "html",
  "intelephense",
  "jsonls",
  "lua_ls",
  "prismals",
  "pyright",
  "rust_analyzer",
  "sqlls",
  "svelte",
  "tailwindcss",
  "templ",
  "terraformls",
  "ts_ls",
  "vue_ls",
  "yamlls",
}

-- enabled if the binary is on PATH, but not installable through mason because
-- the server ships as part of its own toolchain
M.lsp_external = {
  "dartls", -- ships with the Dart SDK
}

-- formatters and linters, mason package names
M.tools = {
  "black",
  "eslint_d",
  "gofumpt",
  "goimports",
  "isort",
  "jsonlint",
  "php-cs-fixer",
  "phpcs",
  "phpstan",
  "prettier",
  "pylama",
  "stylua",
  "tflint",
  "yamllint",
  -- rustfmt is deliberately absent, it comes from rustup not mason
}

return M
