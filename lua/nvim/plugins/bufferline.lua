local present, bufferline = pcall(require, "bufferline")

if not present then
	return
end

local fn = vim.fn

local function diagnostics_indicator(_, _, diagnostics)
	local symbols = { error = " ", warning = " ", info = " " }
	local result = {}
	for name, count in pairs(diagnostics) do
		if symbols[name] and count > 0 then
			table.insert(result, symbols[name] .. count)
		end
	end
	result = table.concat(result, " ")
	return #result > 0 and result or ""
end

local function custom_filter(buf, buf_nums)
	local logs = vim.tbl_filter(function(b)
		return vim.bo[b].filetype == "log"
	end, buf_nums)
	if vim.tbl_isempty(logs) then
		return true
	end
	local tab_num = vim.fn.tabpagenr()
	local last_tab = vim.fn.tabpagenr("$")
	local is_log = vim.bo[buf].filetype == "log"
	if last_tab == 1 then
		return true
	end
	-- only show log buffers in secondary tabs
	return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
end

local groups = require("bufferline.groups")
local options = {
	options = {
		offsets = { { filetype = "NvimTree", text = "Explorer", padding = 1, highlight = "PanelHeading" } },
		--  separator_style = {"",""},
		buffer_close_icon = "",
		modified_icon = "",
		close_icon = "",
		show_close_icon = false,
		left_trunc_marker = " ",
		right_trunc_marker = " ",
		max_name_length = 14,
		max_prefix_length = 13,
		tab_size = 20,
		show_tab_indicators = true,
		enforce_regular_tabs = false,
		view = "multiwindow",
		show_buffer_close_icons = true,
		separator_style = "thin",
		always_show_bufferline = true,
		-- diagnostics = false,
		themable = true,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		diagnostics_indicator = diagnostics_indicator,
		custom_areas = {
			right = function()
				return {
					{ text = "%@Toggle_theme@" .. vim.g.toggle_theme_icon .. "%X" },
					{ text = "%@Quit_vim@ %X" },
				}
			end,
		},
		custom_filter = function(buf_number)
			-- Func to filter out our managed/persistent split terms
			local present_type, type = pcall(function()
				return vim.api.nvim_buf_get_var(buf_number, "term_type")
			end)
			if present_type then
				if type == "vert" then
					return false
				elseif type == "hori" then
					return false
				end
				return true
			end

			return true
		end,
		groups = {
			options = {
				toggle_hidden_on_enter = true,
			},
			items = {
				groups.builtin.ungrouped,
				{
					name = "Terraform",
					matcher = function(buf)
						return buf.name:match("%.tf") ~= nil
					end,
				},
				{
					highlight = { guisp = "#51AFEF", gui = "underline" },
					name = "tests",
					icon = "",
					matcher = function(buf)
						return buf.filename:match("_spec") or buf.filename:match("_test")
					end,
				},
				{
					name = "docs",
					icon = "",
					matcher = function(buf)
						for _, ext in ipairs({ "md", "txt", "org", "norg", "wiki" }) do
							if ext == fn.fnamemodify(buf.path, ":e") then
								return true
							end
						end
					end,
				},
			},
		},
	},
}

bufferline.setup(options)
