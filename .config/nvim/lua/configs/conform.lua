local options = {
  formatters_by_ft = {
    css = { "prettier" },
    go = { "gofumpt", "goimports" },
    graphql = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    json = { "prettier" },
    lua = { "stylua" },
    markdown = { "prettier" },
    php = { "php_cs_fixer" },
    python = { "isort", "black" },
    ruby = { "rubyfmt" },
    rust = { "rustfmt" },
    svelte = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    vue = { "prettier" },
    yaml = { "prettier" },
  },

  format_on_save = {
    -- lsp_fallback was renamed, conform warns on the old key
    lsp_format = "fallback",
    async = false,
    timeout_ms = 1000,
  },
}

return options
