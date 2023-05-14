local fn, api, cmd, fmt = vim.fn, vim.api, vim.cmd, string.format
local l = vim.log.levels
local M = {}

----------------------------------------------------------------------------------------------------
-- Utils
----------------------------------------------------------------------------------------------------

--- Convert a list or map of items into a value by iterating all it's fields and transforming
--- them with a callback
---@generic T, S
---@param callback fun(acc: S, item: T, key: string | number): S
---@param list T[]
---@param accum S?
---@return S
function M.fold(callback, list, accum)
	accum = accum or {}
	for k, v in pairs(list) do
		accum = callback(accum, v, k)
		assert(accum ~= nil, "The accumulator must be returned on each iteration")
	end
	return accum
end

---@generic T
---@param callback fun(item: T, key: string | number, list: T[]): T
---@param list T[]
---@return T[]
function M.map(callback, list)
	return M.fold(function(accum, v, k)
		accum[#accum + 1] = callback(v, k, accum)
		return accum
	end, list, {})
end

---@generic T:table
---@param callback fun(item: T, key: any)
---@param list table<any, T>
function M.foreach(callback, list)
	for k, v in pairs(list) do
		callback(v, k)
	end
end

--- Check if the target matches  any item in the list.
---@param target string
---@param list string[]
---@return boolean
function M.any(target, list)
	for _, item in ipairs(list) do
		if target:match(item) then
			return true
		end
	end
	return false
end

---Find an item in a list
---@generic T
---@param matcher fun(arg: T):boolean
---@param haystack T[]
---@return T?
function M.find(matcher, haystack)
	for _, needle in ipairs(haystack) do
		if matcher(needle) then
			return needle
		end
	end
end

function M.installed_plugins()
	local ok, lazy = pcall(require, "lazy")
	if not ok then
		return 0
	end
	return lazy.stats().count
end

--- Autosize horizontal split to match its minimum content
--- https://vim.fandom.com/wiki/Automatically_fitting_a_quickfix_window_height
---@param min_height number
---@param max_height number
function M.adjust_split_height(min_height, max_height)
	api.nvim_win_set_height(0, math.max(math.min(fn.line("$"), max_height), min_height))
end

---------------------------------------------------------------------------------
-- Quickfix and Location List
---------------------------------------------------------------------------------

M.list = { qf = {}, loc = {} }

---@param list_type "loclist" | "quickfix"
---@return boolean
local function is_list_open(list_type)
	return M.find(function(win)
		return not M.falsy(win[list_type])
	end, fn.getwininfo()) ~= nil
end

local silence = { mods = { silent = true, emsg_silent = true } }

---@param callback fun(...)
local function preserve_window(callback, ...)
	local win = api.nvim_get_current_win()
	callback(...)
	if win ~= api.nvim_get_current_win() then
		cmd.wincmd("p")
	end
end

function M.list.qf.toggle()
	if is_list_open("quickfix") then
		cmd.cclose(silence)
	elseif #fn.getqflist() > 0 then
		preserve_window(cmd.copen, silence)
	end
end

function M.list.loc.toggle()
	if is_list_open("loclist") then
		cmd.lclose(silence)
	elseif #fn.getloclist(0) > 0 then
		preserve_window(cmd.lopen, silence)
	end
end

-- @see: https://vi.stackexchange.com/a/21255
-- using range-aware function
function M.list.qf.delete(bufnr)
	bufnr = bufnr or api.nvim_get_current_buf()
	local list = fn.getqflist()
	local line = api.nvim_win_get_cursor(0)[1]
	-- FIXME: get visual selection so this functionality can work in visual mode
	if api.nvim_get_mode().mode == "v" then
		local first_line = api.nvim_buf_get_mark(0, "<")[1]
		local last_line = api.nvim_buf_get_mark(0, ">")[1]
		list = M.fold(function(accum, item, i)
			if i < first_line or i > last_line then
				table.insert(accum, item)
			end
			return accum
		end, list)
	else
		table.remove(list, line)
	end
	-- replace items in the current list, do not make a new copy of it; this also preserves the list title
	fn.setqflist({}, "r", { items = list })
	fn.setpos(".", { bufnr, line, 1, 0 }) -- restore current line
end
---------------------------------------------------------------------------------

---@param str string
---@param max_len integer
---@return string
function M.truncate(str, max_len)
	assert(str and max_len, "string and max_len must be provided")
	return api.nvim_strwidth(str) > max_len and str:sub(1, max_len) .. M.ui.icons.misc.ellipsis or str
end

---Determine if a value of any type is empty
---@param item any
---@return boolean?
function M.falsy(item)
	if not item then
		return true
	end
	local item_type = type(item)
	if item_type == "boolean" then
		return not item
	end
	if item_type == "string" then
		return item == ""
	end
	if item_type == "number" then
		return item <= 0
	end
	if item_type == "table" then
		return vim.tbl_isempty(item)
	end
	return item ~= nil
end

--- Call the given function and use `vim.notify` to notify of any errors
--- this function is a wrapper around `xpcall` which allows having a single
--- error handler for all errors
---@param msg string
---@param func function
---@param ... any
---@return boolean, any
---@overload fun(func: function, ...): boolean, any
function M.pcall(msg, func, ...)
	local args = { ... }
	if type(msg) == "function" then
		local arg = func --[[@as any]]
		args, func, msg = { arg, unpack(args) }, msg, nil
	end
	return xpcall(func, function(err)
		msg = debug.traceback(msg and fmt("%s:\n%s", msg, err) or err)
		vim.schedule(function()
			vim.notify(msg, l.ERROR, { title = "ERROR" })
		end)
	end, unpack(args))
end

local LATEST_NIGHTLY_MINOR = 9
function M.nightly()
	return vim.version().minor >= LATEST_NIGHTLY_MINOR
end

----------------------------------------------------------------------------------------------------
--  FILETYPE HELPERS
----------------------------------------------------------------------------------------------------

---@class FiletypeSettings
---@field g table<string, any>
---@field bo vim.bo
---@field wo vim.wo
---@field opt vim.opt
---@field plugins {[string]: fun(module: table)}

---@param args {[1]: string, [2]: string, [3]: string, [string]: boolean | integer}[]
---@param buf integer
local function apply_ft_mappings(args, buf)
	M.foreach(function(m)
		assert(m[1] and m[2] and m[3], "map args must be a table with at least 3 items")
		local opts = M.fold(function(acc, item, key)
			if type(key) == "string" then
				acc[key] = item
			end
			return acc
		end, m, { buffer = buf })
		map(m[1], m[2], m[3], opts)
	end, args)
end

--- A convenience wrapper that calls the ftplugin config for a plugin if it exists
--- and warns me if the plugin is not installed
---@param configs table<string, fun(module: table)>
function M.ftplugin_conf(configs)
	if type(configs) ~= "table" then
		return
	end
	for name, callback in pairs(configs) do
		local ok, plugin = M.pcall(require, name)
		if ok then
			callback(plugin)
		end
	end
end

--- This function is an alternative API to using ftplugin files. It allows defining
--- filetype settings in a single place, then creating FileType autocommands from this definition
---
--- e.g.
--- ```lua
---   as.filetype_settings({
---     lua = {
---      opt = {foldmethod = 'expr' },
---      bo = { shiftwidth = 2 }
---     },
---    [{'c', 'cpp'}] = {
---      bo = { shiftwidth = 2 }
---    }
---   })
--- ```
--- One future idea is to generate the ftplugin files from this function, so the settings are still
--- centralized but the curation of these files is automated. Although I'm not sure this actually
--- has value over autocommands, unless ftplugin files specifically have that value
---
---@param map {[string|string[]]: FiletypeSettings | {[integer]: fun(args: AutocmdArgs)}}
function M.filetype_settings(map)
	local commands = M.map(function(settings, ft)
		local name = type(ft) == "string" and ft or table.concat(ft, ",")
		return {
			pattern = ft,
			event = "FileType",
			desc = ("ft settings for %s"):format(name),
			command = function(args)
				M.foreach(function(value, scope)
					if scope == "opt" then
						scope = "opt_local"
					end
					if scope == "mappings" then
						return apply_ft_mappings(value, args.buf)
					end
					if scope == "plugins" then
						return M.ftplugin_conf(value)
					end
					if type(value) ~= "table" and vim.is_callable(value) then
						return value(args)
					end
					M.foreach(function(setting, option)
						vim[scope][option] = setting
					end, value)
				end, settings)
			end,
		}
	end, map)
	M.augroup("filetype-settings", unpack(commands))
end

----------------------------------------------------------------------------------------------------
-- API Wrappers
----------------------------------------------------------------------------------------------------
-- Thin wrappers over API functions to make their usage easier/terser

local autocmd_keys = { "event", "buffer", "pattern", "desc", "command", "group", "once", "nested" }
--- Validate the keys passed to as.augroup are valid
---@param name string
---@param command Autocommand
local function validate_autocmd(name, command)
	local incorrect = M.fold(function(accum, _, key)
		if not vim.tbl_contains(autocmd_keys, key) then
			table.insert(accum, key)
		end
		return accum
	end, command, {})

	if #incorrect > 0 then
		vim.schedule(function()
			local msg = "Incorrect keys: " .. table.concat(incorrect, ", ")
			vim.notify(msg, "error", { title = fmt("Autocmd: %s", name) })
		end)
	end
end

---@class AutocmdArgs
---@field id number
---@field event string
---@field group string?
---@field buf number
---@field file string
---@field match string | number
---@field data any

---@class Autocommand
---@field desc string
---@field event  string | string[] list of autocommand events
---@field pattern string | string[] list of autocommand patterns
---@field command string | fun(args: AutocmdArgs): boolean?
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string The name of the autocommand group
---@param ... Autocommand A list of autocommands to create
---@return number
function M.augroup(name, ...)
	local commands = { ... }
	assert(name ~= "User", "The name of an augroup CANNOT be User")
	assert(#commands > 0, fmt("You must specify at least one autocommand for %s", name))
	local id = api.nvim_create_augroup(name, { clear = true })
	for _, autocmd in ipairs(commands) do
		validate_autocmd(name, autocmd)
		local is_callback = type(autocmd.command) == "function"
		api.nvim_create_autocmd(autocmd.event, {
			group = name,
			pattern = autocmd.pattern,
			desc = autocmd.desc,
			callback = is_callback and autocmd.command or nil,
			command = not is_callback and autocmd.command or nil,
			once = autocmd.once,
			nested = autocmd.nested,
			buffer = autocmd.buffer,
		})
	end
	return id
end

--- @class CommandArgs
--- @field args string
--- @field fargs table
--- @field bang boolean,

---Create an nvim command
---@param name string
---@param rhs string | fun(args: CommandArgs)
---@param opts table?
function M.command(name, rhs, opts)
	opts = opts or {}
	api.nvim_create_user_command(name, rhs, opts)
end

---A terser proxy for `nvim_replace_termcodes`
---@param str string
---@return string
function M.replace_termcodes(str)
	return api.nvim_replace_termcodes(str, true, true, true)
end

---check if a certain feature/version/commit exists in nvim
---@param feature string
---@return boolean
function M.has(feature)
	return fn.has(feature) > 0
end

---@generic T
---Given a table return a new table which if the key is not found will search
---all the table's keys for a match using `string.match`
---@param map T
---@return T
function M.p_table(map)
	return setmetatable(map, {
		__index = function(tbl, key)
			if not key then
				return
			end
			for k, v in pairs(tbl) do
				if key:match(k) then
					return v
				end
			end
		end,
	})
end

return M
