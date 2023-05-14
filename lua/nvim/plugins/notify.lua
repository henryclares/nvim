local notify = require("notify")

local banned_messages = { "No information available" }

-- notify.setup({
-- 	timeout = 2000,
-- 	on_open = function(win)
-- 		vim.api.nvim_win_set_config(win, { zindex = 2000 })
-- 	end,
-- })

---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, ...)
	for _, banned in ipairs(banned_messages) do
		if msg == banned then
			return
		end
	end
	return require("notify")(msg, ...)
end

-- vim.notify = notify

-- vim.notify.config({
-- 	position = "bottom_right",
-- 	timeout = 5000,
-- 	background_color = "#FFFF00",
-- })
