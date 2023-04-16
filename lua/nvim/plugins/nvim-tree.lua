local present, nvimtree = pcall(require, "nvim-tree")

if not present then
	return
end

local tree_cb = require("nvim-tree.config").nvim_tree_callback

local options = {
	filters = {
		dotfiles = false,
		exclude = { "custom" },
	},
	disable_netrw = true,
	hijack_netrw = true,
	--  ignore_ft_on_setup = { "alpha" },
	open_on_tab = false,
	hijack_cursor = true,
	hijack_unnamed_buffer_when_opening = false,
	update_cwd = true,
	update_focused_file = {
		enable = true,
		update_cwd = false,
	},
	view = {
		side = "left",
		width = 30,
		-- hide_root_folder = false,
		mappings = {
			list = {
				{ key = "c", cb = tree_cb("create") },
				{ key = "R", cb = tree_cb("refresh") },
				{ key = "i", cb = tree_cb("preview") },
				{ key = "<C-v>", cb = tree_cb("vsplit") }, -- vsplit
				{ key = "<C-s>", cb = tree_cb("split") }, -- split
			},
		},
	},
	git = {
		enable = true,
		ignore = false,
	},
	actions = {
		open_file = {
			resize_window = true,
		},
	},
	renderer = {
		full_name = true,
		highlight_git = true,
		highlight_opened_files = "none",
		root_folder_label = false,
		indent_markers = {
			enable = false,
		},
		icons = {
			padding = " ",
			symlink_arrow = " ➛ ",
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					default = "",
					empty = "",
					empty_open = "",
					open = "",
					symlink = "",
					symlink_open = "",
					arrow_open = "",
					arrow_closed = "",
				},
				git = {
					unstaged = "✗",
					staged = "✓",
					unmerged = "",
					renamed = "➜",
					untracked = "★",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
}
nvimtree.setup(options)
