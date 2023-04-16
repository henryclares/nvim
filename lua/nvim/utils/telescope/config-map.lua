local present, telescope = pcall(require, "telescope")
local vim = vim

if not present then
	return
end

local builtins = require("telescope.builtin")
local fmt, fn = string.format, vim.fn

local M = {}

local function delta_opts(opts, is_buf)
	local previewers = require("telescope.previewers")
	local delta = previewers.new_termopen_previewer({
		get_command = function(entry)
			local args = {
				"git",
				"-c",
				"core.pager=delta",
				"-c",
				"delta.side-by-side=false",
				"diff",
				entry.value .. "^!",
			}
			if is_buf then
				vim.list_extend(args, { "--", entry.current_file })
			end
			return args
		end,
	})
	opts = opts or {}
	opts.previewer = {
		delta,
		previewers.git_commit_message.new(opts),
	}
	return opts
end

function M.rectangular_border(opts)
	return vim.tbl_deep_extend("force", opts or {}, {
		borderchars = {
			prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
			results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
			preview = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
		},
	})
end

function M.dropdown(opts)
	return require("telescope.themes").get_dropdown(M.rectangular_border(opts))
end

function M.ivy(opts)
	return require("telescope.themes").get_ivy(vim.tbl_deep_extend("keep", opts or {}, {
		borderchars = {},
	}))
end

function M.pickers()
	builtins.builtin({ include_extensions = true })
end

function M.notifications()
	telescope.extensions.notify.notify(M.dropdown())
end

function M.installed_plugins()
	builtins.find_files({
		prompt_title = "Installed plugins",
		cwd = fn.stdpath("data") .. "/site/pack/packer",
	})
end

function M.luasnips()
	telescope.extensions.luasnip.luasnip(M.dropdown())
end

function M.find_near_files()
	local cwd = require("telescope.utils").buffer_dir()
	builtins.find_files({
		prompt_title = fmt("Searching %s", fn.fnamemodify(cwd, ":~:.")),
		cwd = cwd,
	})
end

function M.frecency()
	telescope.extensions.frecency.frecency(M.dropdown({
		previewer = false,
	}))
end

function M.delta_git_commits(opts)
	builtins.git_commits(delta_opts(opts))
end

function M.delta_git_bcommits(opts)
	builtins.git_bcommits(delta_opts(opts, true))
end

function M.live_grep_args()
	telescope.extensions.live_grep_args.live_grep_args(M.ivy())
end

function M.orgfiles()
	builtins.find_files({
		prompt_title = "Org",
		cwd = fn.expand("$SYNC_DIR/org/"),
	})
end

function M.norgfiles()
	builtins.find_files({
		prompt_title = "Norg",
		cwd = fn.expand("$SYNC_DIR/neorg/"),
	})
end

M.builtins = builtins

return M
