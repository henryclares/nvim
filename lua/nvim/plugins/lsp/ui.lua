local Highlighter = require("nvim.utils.highlighting.highlighter")
local HighlightGroups = require("nvim.utils.highlighting.highlight-group")
local ThemeManager = require("nvim.utils.theme.theme-manager")

local theme = ThemeManager.get_theme()

local v = vim
local cmd = v.cmd
local lsp = v.lsp

local M = {}

M.border = {
	{ "╭", "FloatBorder" },

	{ "─", "FloatBorder" },

	{ "╮", "FloatBorder" },

	{ "│", "FloatBorder" },

	{ "╯", "FloatBorder" },

	{ "─", "FloatBorder" },

	{ "╰", "FloatBorder" },

	{ "│", "FloatBorder" },
}

local diagnosticHighlightGroups = HighlightGroups({
	DiagnosticLineNrError = {
		guifg = theme.bright.red,
		guibg = theme.normal.red,
	},
	DiagnosticLineNrWarn = {
		guifg = theme.bright.yellow,
		guibg = theme.normal.yellow,
	},
	DiagnosticLineNrInfo = {
		guifg = theme.bright.blue,
		guibg = theme.normal.blue,
	},
	DiagnosticLineNrHint = {
		guifg = theme.bright.cyan,
		guibg = theme.normal.cyan,
	},
})

function M.register_diagnostic_signs()
	vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
	vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
	vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
	vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
end

function M.add_ui()
	cmd(string.format("autocmd ColorScheme * highlight NormalFloat guibg=#1f2335"))
	cmd([[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])

	lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
		border = M.border,
	})

	lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, {
		border = M.border,
	})

	vim.diagnostic.config({
		virtual_text = true,
		signs = true,
		underline = true,
		update_in_insert = true,
		severity_sort = true,
	})

	Highlighter:new():add(diagnosticHighlightGroups):register_highlights()

	vim.cmd([[
	       sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
	       sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
	       sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
	       sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint
	   ]])
end

function M.setup()
	M.add_ui()
	M.register_diagnostic_signs()
end

return M
