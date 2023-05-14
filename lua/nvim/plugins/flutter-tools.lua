-- local opt = vim.opt
local g = vim.g
local ui = require("nvim.core.ui")

function _G.statusLine()
	return g.flutter_tools_decorations.app_version
end

-- opt.statusline = "%!v:statusLine()"

require("flutter-tools").setup({
	ui = { border = ui.ui.current.border },
	debugger = {
		enabled = false,
		run_via_dap = false,
		exception_breakpoints = {},
	},
	outline = { auto_open = false },
	decorations = {
		statusline = { device = true, app_version = true },
	},
	widget_guides = { enabled = true, debug = false },
	dev_log = { enabled = false, open_cmd = "tabedit" },
	lsp = {
		color = {
			enabled = true,
			background = true,
			virtual_text = false,
		},
		settings = {
			showTodos = false,
			renameFilesWithClasses = "prompt",
			updateImportsOnRename = true,
			completeFunctionCalls = true,
			lineLength = 100,
		},
	},
})
