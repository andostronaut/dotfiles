local lint = require "lint"

-- deno projects lint with deno, everything else with eslint_d
local function ts_js_linter()
  local stat = vim.uv.fs_stat "deno.json"
  return (stat and stat.type == "file") and "deno" or "eslint_d"
end

lint.linters_by_ft = {
  javascript = { ts_js_linter() },
  javascriptreact = { "eslint_d" },
  json = { "jsonlint" },
  php = { "phpcs", "phpstan" },
  python = { "pylama" },
  svelte = { "eslint_d" },
  terraform = { "tflint" },
  typescript = { ts_js_linter() },
  typescriptreact = { "eslint_d" },
  vue = { "eslint_d" },
  yaml = { "yamllint" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

-- only run linters whose binary is actually present, otherwise nvim-lint raises
-- an ENOENT on every single BufEnter until mason has installed everything
local function available_linters()
  local names = lint.linters_by_ft[vim.bo.filetype]
  if not names then
    return {}
  end

  local found = {}

  for _, name in ipairs(names) do
    local linter = lint.linters[name]
    local cmd = type(linter) == "table" and linter.cmd or nil

    -- cmd may be a function, eslint_d resolves a local node_modules binary
    if type(cmd) == "function" then
      local ok, resolved = pcall(cmd)
      cmd = ok and resolved or nil
    end

    -- anything we cannot resolve to a path is left in, nvim-lint decides
    if type(cmd) ~= "string" or vim.fn.executable(cmd) == 1 then
      table.insert(found, name)
    end
  end

  return found
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    local names = available_linters()

    if #names > 0 then
      lint.try_lint(names)
    end
  end,
})

vim.keymap.set("n", "<leader>l", function()
  lint.try_lint()
end, { desc = "Lint current file" })
