-- nvim-treesitter's main branch dropped the declarative `textobjects = {...}`
-- table, so the same keymaps are built here against the imperative API.

require("nvim-treesitter-textobjects").setup {
  select = {
    lookahead = true, -- jump forward to the textobject, like targets.vim
  },
  move = {
    set_jumps = true, -- record moves in the jumplist
  },
}

local select = require "nvim-treesitter-textobjects.select"
local swap = require "nvim-treesitter-textobjects.swap"
local move = require "nvim-treesitter-textobjects.move"
local repeatable = require "nvim-treesitter-textobjects.repeatable_move"

local map = vim.keymap.set

-- selection
for lhs, spec in pairs {
  ["a="] = { "@assignment.outer", "outer part of an assignment" },
  ["i="] = { "@assignment.inner", "inner part of an assignment" },
  ["l="] = { "@assignment.lhs", "left hand side of an assignment" },
  ["r="] = { "@assignment.rhs", "right hand side of an assignment" },

  ["a:"] = { "@property.outer", "outer part of an object property" },
  ["i:"] = { "@property.inner", "inner part of an object property" },
  ["l:"] = { "@property.lhs", "left part of an object property" },
  ["r:"] = { "@property.rhs", "right part of an object property" },

  ["aa"] = { "@parameter.outer", "outer part of a parameter" },
  ["ia"] = { "@parameter.inner", "inner part of a parameter" },

  ["ai"] = { "@conditional.outer", "outer part of a conditional" },
  ["ii"] = { "@conditional.inner", "inner part of a conditional" },

  ["al"] = { "@loop.outer", "outer part of a loop" },
  ["il"] = { "@loop.inner", "inner part of a loop" },

  ["af"] = { "@call.outer", "outer part of a function call" },
  ["if"] = { "@call.inner", "inner part of a function call" },

  ["am"] = { "@function.outer", "outer part of a function definition" },
  ["im"] = { "@function.inner", "inner part of a function definition" },

  ["ac"] = { "@class.outer", "outer part of a class" },
  ["ic"] = { "@class.inner", "inner part of a class" },
} do
  local query, desc = spec[1], spec[2]
  map({ "x", "o" }, lhs, function()
    select.select_textobject(query, "textobjects")
  end, { desc = "Select " .. desc })
end

-- swapping
for lhs, spec in pairs {
  ["<leader>na"] = { "@parameter.inner", "parameter" },
  ["<leader>n:"] = { "@property.outer", "object property" },
  ["<leader>nm"] = { "@function.outer", "function" },
} do
  local query, what = spec[1], spec[2]
  map("n", lhs, function()
    swap.swap_next(query)
  end, { desc = "Swap " .. what .. " with next" })
end

for lhs, spec in pairs {
  ["<leader>pa"] = { "@parameter.inner", "parameter" },
  ["<leader>p:"] = { "@property.outer", "object property" },
  ["<leader>pm"] = { "@function.outer", "function" },
} do
  local query, what = spec[1], spec[2]
  map("n", lhs, function()
    swap.swap_previous(query)
  end, { desc = "Swap " .. what .. " with previous" })
end

-- movement, `group` is the query file the capture lives in
local movements = {
  { move.goto_next_start, {
    ["]f"] = { "@call.outer", "textobjects", "function call start" },
    ["]m"] = { "@function.outer", "textobjects", "function def start" },
    ["]c"] = { "@class.outer", "textobjects", "class start" },
    ["]i"] = { "@conditional.outer", "textobjects", "conditional start" },
    ["]l"] = { "@loop.outer", "textobjects", "loop start" },
    ["]s"] = { "@scope", "locals", "scope" },
    ["]z"] = { "@fold", "folds", "fold" },
  }, "Next " },
  { move.goto_next_end, {
    ["]F"] = { "@call.outer", "textobjects", "function call end" },
    ["]M"] = { "@function.outer", "textobjects", "function def end" },
    ["]C"] = { "@class.outer", "textobjects", "class end" },
    ["]I"] = { "@conditional.outer", "textobjects", "conditional end" },
    ["]L"] = { "@loop.outer", "textobjects", "loop end" },
  }, "Next " },
  { move.goto_previous_start, {
    ["[f"] = { "@call.outer", "textobjects", "function call start" },
    ["[m"] = { "@function.outer", "textobjects", "function def start" },
    ["[c"] = { "@class.outer", "textobjects", "class start" },
    ["[i"] = { "@conditional.outer", "textobjects", "conditional start" },
    ["[l"] = { "@loop.outer", "textobjects", "loop start" },
  }, "Prev " },
  { move.goto_previous_end, {
    ["[F"] = { "@call.outer", "textobjects", "function call end" },
    ["[M"] = { "@function.outer", "textobjects", "function def end" },
    ["[C"] = { "@class.outer", "textobjects", "class end" },
    ["[I"] = { "@conditional.outer", "textobjects", "conditional end" },
    ["[L"] = { "@loop.outer", "textobjects", "loop end" },
  }, "Prev " },
}

for _, entry in ipairs(movements) do
  local fn, keys, prefix = entry[1], entry[2], entry[3]

  for lhs, spec in pairs(keys) do
    local query, group, desc = spec[1], spec[2], spec[3]
    map({ "n", "x", "o" }, lhs, function()
      fn(query, group)
    end, { desc = prefix .. desc })
  end
end

-- ; and , repeat the last textobject move, and make builtin f/F/t/T repeatable too
map({ "n", "x", "o" }, ";", repeatable.repeat_last_move)
map({ "n", "x", "o" }, ",", repeatable.repeat_last_move_opposite)

map({ "n", "x", "o" }, "f", repeatable.builtin_f_expr, { expr = true })
map({ "n", "x", "o" }, "F", repeatable.builtin_F_expr, { expr = true })
map({ "n", "x", "o" }, "t", repeatable.builtin_t_expr, { expr = true })
map({ "n", "x", "o" }, "T", repeatable.builtin_T_expr, { expr = true })
