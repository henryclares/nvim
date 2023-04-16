local present, blankline = pcall(require, "indent_blankline")

if not present then
	return
end

--    require("base46").load_highlight "blankline"

local options = {
	-- indentLine_enabled = 1,
	char = "▏",
	filetype_exclude = {
		"help",
		"terminal",
		"alpha",
		"packer",
		"lspinfo",
		"TelescopePrompt",
		"TelescopeResults",
		"lsp-installer",
		"",
	},
	-- buftype_exclude = { "terminal" },
	show_trailing_blankline_indent = false,
	-- show_first_indent_level = false,
	show_current_context = true,
	-- show_current_context_start = true,
}

blankline.setup(options)
-- vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
-- vim.g.indent_blankline_filetype_exclude = {
-- 	"help",
-- 	"startify",
-- 	"dashboard",
-- 	"packer",
-- 	"neogitstatus",
-- 	"NvimTree",
-- 	"Trouble",
-- }
-- vim.g.indent_blankline_char = "│"
-- vim.g.indent_blankline_use_treesitter = true
-- vim.g.indent_blankline_show_trailing_blankline_indent = false
-- vim.g.indent_blankline_show_current_context = true
-- vim.g.indent_blankline_context_patterns = {
-- 	"class",
-- 	"return",
-- 	"function",
-- 	"method",
-- 	"^if",
-- 	"^while",
-- 	"jsx_element",
-- 	"tsx_element",
-- 	"^for",
-- 	"^object",
-- 	"^table",
-- 	"block",
-- 	"arguments",
-- 	"if_statement",
-- 	"else_clause",
-- 	"jsx_element",
-- 	"jsx_self_closing_element",
-- 	"tsx_self_closing_element",
-- 	"try_statement",
-- 	"catch_clause",
-- 	"import_statement",
-- 	"operation_type",
-- }
-- -- HACK: work-around for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
-- vim.wo.colorcolumn = "99999"
