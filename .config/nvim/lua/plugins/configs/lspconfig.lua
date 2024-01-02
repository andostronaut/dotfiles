dofile(vim.g.base46_cache .. "lsp")
require "nvchad.lsp"

local M = {}
local utils = require "core.utils"

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
  end

  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

require("lspconfig").lua_ls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

require("lspconfig").html.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").cssls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").tailwindcss.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").svelte.setup {
  capabilities = M.capabilities,
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.js", "*.ts" },
      callback = function(ctx)
        if client.name == "svelte" then
          client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
        end
      end,
    })
  end,
}

require("lspconfig").prismals.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").graphql.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
}

require("lspconfig").emmet_ls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
}

require("lspconfig").pyright.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").angularls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").astro.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").tsserver.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("deno-nvim").setup {
  server = {
    capabilities = M.capabilities,
    root_dir = require("lspconfig").util.root_pattern "deno.json",
    on_attach = function()
      local active_clients = vim.lsp.get_active_clients()

      for _, client in pairs(active_clients) do
        if client.name == "tsserver" then
          client.stop()
        end
      end
    end,
  },
}

require("lspconfig").dockerls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").helm_ls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "helm" },
}

require("lspconfig").jsonls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "json" },
}

require("lspconfig").pylsp.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "py" },
}

require("lspconfig").ruby_ls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "rb" },
}

require("lspconfig").rust_analyzer.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "rs" },
}

require("lspconfig").terraformls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").volar.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "vue" },
}

require("lspconfig").bashls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").sqlls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "sql" },
}

require("lspconfig").gopls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

return M
