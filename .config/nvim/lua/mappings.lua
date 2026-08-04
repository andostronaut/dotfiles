require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- git diff -------------------------------------------------------------------
-- NvChad ships gitsigns and only maps <leader>cm / <leader>gt, so the hunk and
-- diff actions need wiring up by hand.

local gs = function(fn, ...)
  local args = { ... }
  return function()
    require("gitsigns")[fn](unpack(args))
  end
end

-- hunk level, gitsigns
map("n", "]h", gs("nav_hunk", "next"), { desc = "git next hunk" })
map("n", "[h", gs("nav_hunk", "prev"), { desc = "git prev hunk" })
map("n", "<leader>gp", gs "preview_hunk", { desc = "git preview hunk" })
map("n", "<leader>gs", gs "stage_hunk", { desc = "git stage hunk" })
map("n", "<leader>gr", gs "reset_hunk", { desc = "git reset hunk" })
map("n", "<leader>gb", gs("blame_line", { full = true }), { desc = "git blame line" })
map("n", "<leader>gv", gs "diffthis", { desc = "git diff this file vs index" })
map("n", "<leader>ga", gs "blame", { desc = "git blame whole file" })

-- persistent inline blame, git-blame.nvim starts disabled
map("n", "<leader>gB", "<cmd>GitBlameToggle<cr>", { desc = "git blame inline toggle" })
map("n", "<leader>gu", "<cmd>GitBlameOpenCommitURL<cr>", { desc = "git blame open commit url" })
map("n", "<leader>gy", "<cmd>GitBlameCopySHA<cr>", { desc = "git blame copy commit sha" })

-- file and repo level, diffview
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "git diff working tree" })
map("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "git diff close" })
map("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "git history current file" })
map("n", "<leader>gF", "<cmd>DiffviewFileHistory<cr>", { desc = "git history repo" })
map("n", "<leader>gl", "<cmd>Flog<cr>", { desc = "git commit graph" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
