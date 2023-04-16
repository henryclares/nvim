-- import lspsaga safely
local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
	return
end

local highlight = require("nvim.plugins.lsp.highlight")

saga.setup({
	-- -- keybinds for navigation in lspsaga window
	-- scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
	-- -- use enter to open file with definition preview
	-- definition = {
	-- 	edit = "<CR>",
	-- },
	-- ui = {
	-- 	colors = {
	-- 		normal_bg = "#022746",
	-- 	},
	-- },
	server_filetype_map = {
		typescript = "typescript",
	},
})

highlight.get_colors()
highlight.init_highlight()
