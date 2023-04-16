-- local opt = vim.opt
local g = vim.g

function _G.statusLine()
	return g.flutter_tools_decorations.app_version
end

-- opt.statusline = "%!v:statusLine()"

require("flutter-tools").setup({})
