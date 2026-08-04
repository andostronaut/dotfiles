require "nvchad.autocmds"

-- base46 has no notion of the OS appearance, theme_toggle is manual only, so
-- follow macOS by hand to stay in step with ghostty and herdr. The pair here
-- has to match theme_toggle in chadrc.lua.
local appearance_themes = { dark = "catppuccin", light = "catppuccin-latte" }

-- base46 compiles highlights into a cache that records nothing about which
-- theme produced it, and the cache drifts from the theme chadrc declares, so
-- keep our own note of what was actually compiled. Rebuilding costs ~35ms,
-- which is worth avoiding on every start and every focus.
local applied_marker = vim.g.base46_cache .. "os_appearance_theme"

local function applied_theme()
  local f = io.open(applied_marker, "r")
  if not f then
    return nil
  end

  local name = f:read "l"
  f:close()
  return name
end

local function sync_theme_with_os()
  -- AppleInterfaceStyle is "Dark" in dark mode and simply absent in light mode
  vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }, function(out)
    local dark = out.code == 0 and out.stdout:find "Dark" ~= nil
    local want = dark and appearance_themes.dark or appearance_themes.light

    vim.schedule(function()
      -- always, so theme_toggle sees the theme that is actually on screen
      -- rather than the one chadrc declares
      require("nvconfig").base46.theme = want

      if applied_theme() == want then
        return
      end

      require("base46").load_all_highlights()

      local f = io.open(applied_marker, "w")
      if f then
        f:write(want)
        f:close()
      end
    end)
  end)
end

vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
  desc = "match the colorscheme to the macOS light/dark appearance",
  callback = sync_theme_with_os,
})

-- helm charts are templated yaml, detect them so yamlls can stay quiet on them
local function is_helm_file(path)
  local chart = vim.fs.find("Chart.yaml", { path = vim.fs.dirname(path), upward = true })
  return not vim.tbl_isempty(chart)
end

vim.filetype.add {
  extension = {
    yaml = function(path)
      return is_helm_file(path) and "helm" or "yaml"
    end,
    yml = function(path)
      return is_helm_file(path) and "helm" or "yaml"
    end,
    tmpl = function(path)
      return is_helm_file(path) and "templ" or "template"
    end,
    tpl = function(path)
      return is_helm_file(path) and "templ" or "smarty"
    end,
  },
  filename = {
    ["Chart.yaml"] = "yaml",
    ["Chart.lock"] = "yaml",
  },
}
