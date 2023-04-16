-- import nvim-cmp plugin safely
local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
	return
end

local types = require("cmp.types")
-- import luasnip plugin safely
local luasnip_status, luasnip = pcall(require, "luasnip")
if not luasnip_status then
	return
end

-- import lspkind plugin safely
local lspkind_status, lspkind = pcall(require, "lspkind")
if not lspkind_status then
	return
end

-- load vs-code like snippets from plugins (e.g. friendly-snippets)
require("luasnip/loaders/from_vscode").lazy_load()

local icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "ﰠ",
	Variable = "",
	Class = "ﴯ",
	Interface = "",
	Module = "",
	Property = "ﰠ",
	Unit = "塞",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "פּ",
	Event = "",
	Operator = "",
	TypeParameter = "",
	Namespace = "?",
	Package = "?",
	String = "?",
	Number = "?",
	Boolean = "?",
	Array = "?",
	Object = "?",
	Key = "?",
	Null = "?",
}

local fmt = string.format
local ellipsis = "…"

local function formatCmp(entry, vim_item)
	local MAX = math.floor(vim.o.columns * 0.5)
	if #vim_item.abbr >= MAX then
		vim_item.abbr = vim_item.abbr:sub(1, MAX) .. ellipsis
	end
	vim_item.kind = fmt("%s %s", icons[vim_item.kind], vim_item.kind)
	vim_item.menu = ({
		nvim_lsp = "[LSP]",
		nvim_lua = "[Lua]",
		emoji = "[E]",
		path = "[Path]",
		neorg = "[N]",
		luasnip = "[SN]",
		dictionary = "[D]",
		buffer = "[B]",
		spell = "[SP]",
		cmdline = "[Cmd]",
		cmdline_history = "[Hist]",
		orgmode = "[Org]",
		norg = "[Norg]",
		rg = "[Rg]",
		git = "[Git]",
	})[entry.source.name]
	return vim_item
end

vim.opt.completeopt = "menu,menuone,noselect"

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
		["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
		["<C-e>"] = cmp.mapping.abort(), -- close completion window
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif require("luasnip").expand_or_jumpable() then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	}),
	-- sources for autocompletion
	sources = cmp.config.sources({
		{ name = "nvim_lsp" }, -- lsp
		{ name = "luasnip" }, -- snippets
		{ name = "buffer" }, -- text within current buffer
		{ name = "path" }, -- file system paths
	}),
	-- configure lspkind for vs-code like icons
	formatting = {
		-- format = lspkind.cmp_format({
		-- 	maxwidth = 50,
		-- 	ellipsis_char = "...",
		-- }),

		format = formatCmp,
	},
	completion = {
		keyword_length = 1,
		completeopt = "menu,menuone,preview,noinsert",
	},
	confirmation = {
		default_behavior = types.cmp.ConfirmBehavior.Replace,
	},
	preselect = cmp.PreselectMode.None,
})

-- cmp.config.formatting = {
-- 	format = require("tailwindcss-colorizer-cmp").formatter,
-- }
