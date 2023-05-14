require("nvim.core.options")
require("nvim.core.keymaps")
require("nvim.core.packer")

local has = vim.fn.has
local is_mac = has("macunix")
if is_mac then
	require("nvim.core.macos")
end
-- require("nvim.core.highlights")
