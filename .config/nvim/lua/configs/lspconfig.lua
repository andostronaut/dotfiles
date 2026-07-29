require("nvchad.configs.lspconfig").defaults()

local servers = require "configs.servers"

-- NvChad's defaults() already registers capabilities, on_init and the LspAttach
-- keymaps against vim.lsp.config("*"), and configures lua_ls. Everything below
-- is per-server overrides on top of that.

vim.lsp.config("tailwindcss", {
  root_markers = {
    "tailwind.config.cjs",
    "tailwind.config.js",
    "tailwind.config.ts",
    "postcss.config.cjs",
    "postcss.config.js",
    "postcss.config.ts",
  },
})

vim.lsp.config("graphql", {
  filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
})

vim.lsp.config("emmet_ls", {
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

-- svelte does not watch js/ts files itself, it has to be told they changed
vim.lsp.config("svelte", {
  on_attach = function(client)
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.js", "*.ts" },
      callback = function(ctx)
        client:notify("$/onDidChangeTsOrJsFile", { uri = vim.uri_from_fname(ctx.file) })
      end,
    })
  end,
})

-- deno and ts_ls both claim javascript and typescript. Scoping each to its own
-- project marker keeps only one of them attached per project. This replaces
-- deno-nvim, which stopped tsserver by hand.
vim.lsp.config("denols", {
  root_markers = { "deno.json", "deno.jsonc" },
  workspace_required = true,
})

vim.lsp.config("ts_ls", {
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
  workspace_required = true,
})

vim.lsp.config("pyright", {
  settings = {
    pyright = {
      disableLanguageServices = false,
      disableOrganizeImports = false,
    },
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace", -- openFilesOnly, workspace
        typeCheckingMode = "basic", -- off, basic, strict
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.config("solargraph", {
  settings = {
    solargraph = {
      diagnostics = true,
      completion = true,
      initializationOptions = {
        formatting = true,
      },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
      diagnostics = {
        enable = true,
      },
    },
  },
})

-- helm charts are templated yaml, so yamlls only produces noise on them
vim.lsp.config("yamlls", {
  on_attach = function(_, bufnr)
    if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
      vim.diagnostic.enable(false, { bufnr = bufnr })
    end
  end,
})

vim.lsp.enable(servers.lsp)
vim.lsp.enable(servers.lsp_external)
