-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "onedark",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

-- the dashboard NvChad shows in its screenshots, off in the starter by default
M.nvdash = { load_on_startup = true }

M.ui = {
	-- show the buffer tabline immediately instead of waiting for a 2nd buffer
	tabufline = {
		lazyload = false,
	},
}

return M
