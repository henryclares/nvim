vim.notify = require("notify")

require("notify").setup({
	timeout = 3000,
	max_height = function()
		return math.floor(vim.o.lines * 0.75)
	end,
	max_width = function()
		return math.floor(vim.o.columns * 0.75)
	end,
	stages = "slide",
})

-- vim.notify.config({
-- 	position = "bottom_right",
-- 	timeout = 5000,
-- 	background_color = "#FFFF00",
-- })
