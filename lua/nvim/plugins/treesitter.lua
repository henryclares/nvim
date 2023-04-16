-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

-- configure treesitter
treesitter.setup({
	-- enable syntax highlighting
	highlight = {
		enable = true,
	},
	-- enable indentation
	indent = { enable = false },
	-- enable autotagging (w/ nvim-ts-autotag plugin)
	autotag = { enable = true },
	-- ensure these language parsers are installed
	ensure_installed = {
		"json",
		"javascript",
		"typescript",
		"tsx",
		"yaml",
		"html",
		"css",
		"markdown",
		"markdown_inline",
		"svelte",
		"graphql",
		"bash",
		"lua",
		"vim",
		"dart",
	},
	-- auto install above language parsers
	auto_install = true,
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = ",s",
			node_incremental = ",s",
			scope_incremental = ",n",
			node_decremental = ",n",
		},
	},
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["kt"] = "@function.inner",
				["ks"] = "@parameter.inner",
				["ka"] = "@class.inner",

				["at"] = "@function.outer",
				["as"] = "@parameter.inner",
				["aa"] = "@class.outer",
			},
		},

		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]t"] = "@function.outer",
				["]s"] = "@parameter.inner",
				["]a"] = "@class.outer",
			},
			goto_previous_start = {
				["[t"] = "@function.outer",
				["[s"] = "@parameter.inner",
				["[a"] = "@class.outer",
			},
			goto_next_end = {
				["]T"] = "@function.outer",
				["]S"] = "@parameter.inner",
				["]A"] = "@class.outer",
			},
			goto_previous_end = {
				["[T"] = "@function.outer",
				["[S"] = "@parameter.inner",
				["[A"] = "@class.outer",
			},
		},
	},
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tsx.filetype_to_parsename = { "javascript", "typescript.tsx", "javascriptreact", "typescript" }
