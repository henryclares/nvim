-- if status == nil then
-- 	return print("dap not loaded")
-- end
--
local dap = require("dap") -- NOTE: Must be loaded before the signs can be tweaked
local dapui = require("dapui")
local ui = require("nvim.core.ui")
local highlight = require("nvim.utils.highlighting").highlight

local fn = vim.fn
local icons = ui.ui.icons
local border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }

local as = { debug = { layout = { ft = { dart = 2 } } } }

highlight.plugin("dap", {
	{ DapBreakpoint = { fg = ui.ui.palette.light_red } },
	{ DapStopped = { fg = ui.ui.palette.green } },
})

fn.sign_define({
	{
		name = "DapBreakpoint",
		texthl = "DapBreakpoint",
		text = icons.misc.bug,
		linehl = "",
		numhl = "",
	},
	{
		name = "DapStopped",
		texthl = "DapStopped",
		text = icons.misc.bookmark,
		linehl = "",
		numhl = "",
	},
})

-- DON'T automatically stop at exceptions
-- dap.defaults.fallback.exception_breakpoints = {}

dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open(as.debug.layout.ft[vim.bo.ft])
end

local options = {
	windows = { indent = 2 },
	floating = { border = border },
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.25 },
				{ id = "breakpoints", size = 0.25 },
				{ id = "stacks", size = 0.25 },
				{ id = "watches", size = 0.25 },
			},
			position = "left",
			size = 20,
		},
		{ elements = { { id = "repl", size = 0.9 } }, position = "bottom", size = 10 },
	},
}
-- dap.setup(options)
