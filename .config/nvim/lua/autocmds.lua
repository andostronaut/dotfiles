require "nvchad.autocmds"

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
