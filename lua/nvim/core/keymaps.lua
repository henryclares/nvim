--  -- set leader key to space
local keymap = vim.keymap.set -- for conciseness
local fn = vim.fn
local as = { debug = { layout = { ft = { dart = 2 } } } }

--  buffer read/write
keymap("n", ",q", ":q<CR>")
keymap("n", ",w", ":w<CR>")

-- clear search highlihts
keymap("n", "<S-l>", ":nohlsearch<CR>")

-- delete single character without copying into register
keymap("n", "x", '"_x')

-- select all
keymap("n", "<C-a>", "gg<S-v>G")

-- save in mode normal
keymap("n", "<C-s>", "<cmd> w <CR>")

-- window management
keymap("n", "ss", "<cmd> :split<Return><C-w>w") -- split window down
keymap("n", "sv", ":vsplit<Return><C-w>w") -- split window right

-- winddow move
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-l>", "<C-w>l")

-- move line
-- Mover líneas hacia abajo y reindentarlas
keymap("n", ";j", ":m .+1<CR>==", { noremap = true })
keymap("i", ";j", "<Esc>:m .+1<CR>==gi", { noremap = true })
keymap("v", ";j", ":m '>+1<CR>gv=gv", { noremap = true })

-- Mover líneas hacia arriba y reindentarlas
keymap("n", ";k", ":m .-2<CR>==", { noremap = true })
keymap("i", ";k", "<Esc>:m .-2<CR>==gi", { noremap = true })
keymap("v", ";k", ":m '<-2<CR>gv=gv", { noremap = true })

-- nvim tree
keymap("n", "<C-n>", "<cmd> NvimTreeToggle <CR>")
keymap("n", "<leader>e", "<cmd> NvimTreeFocus <CR>")

--telescope

keymap("n", "<leader>ff", "<cmd> Telescope find_files <CR>")
keymap("n", "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>")
keymap("n", "<leader>fw", "<cmd> Telescope live_grep <CR>")
keymap("n", "<leader>fb", "<cmd> Telescope buffers <CR>")
keymap("n", "<leader>fh", "<cmd> Telescope help_tags <CR>")
keymap("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>")
keymap("n", "<leader>tk", "<cmd> Telescope keymaps <CR>")

keymap("n", "<leader>cm", "<cmd> Telescope git_commits <CR>")
keymap("n", "<leader>gt", "<cmd> Telescope git_status  <CR>")

-- lsp saga
keymap("n", "gi", "<cmd>Lspsaga lsp_finder<CR>")

-- maximizer
keymap("n", "<silent><F3>", "<cmd>MaximizerToggle<CR>")
keymap("v", "<silent><F3>", "<cmd>MaximizerToggle<CR>gv")
keymap("i", "<silent><F3>", "<C-o>:MaximizerToggle<CR>")

-- Code action
keymap({ "n", "v" }, "ga", "<cmd>Lspsaga code_action<CR>")

-- Rename all occurrences of the hovered word for the entire file
keymap("n", "rg", "<cmd>Lspsaga rename<CR>")

-- Rename all occurrences of the hovered word for the selected files
-- keymap("n", "gr", "<cmd>Lspsaga rename ++project<CR>")

-- Peek definition
-- You can edit the file containing the definition in the floating window
-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
-- It also supports tagstack
-- Use <C-t> to jump back
-- keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")

-- Go to definition
-- keymap("n","gd", "<cmd>Lspsaga goto_definition<CR>")

-- Peek type definition
-- You can edit the file containing the type definition in the floating window
-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
-- It also supports tagstack
-- Use <C-t> to jump back
keymap("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")

-- Go to type definition
keymap("n", "gt", "<cmd>Lspsaga goto_type_definition<CR>")

-- Show line diagnostics
-- You can pass argument ++unfocus to
-- unfocus the show_line_diagnostics floating window
keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")

-- Show cursor diagnostics
-- Like show_line_diagnostics, it supports passing the ++unfocus argument
keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

-- Show buffer diagnostics
keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")

-- Diagnostic jump
-- You can use <C-o> to jump back to your previous location
keymap("n", ".e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
keymap("n", ",e", "<cmd>Lspsaga diagnostic_jump_next<CR>")
keymap("n", "<leader>dd", "<cmd>Telescope diagnostics<CR>", { noremap = true, silent = true })

-- Diagnostic jump with filters such as only jumping to an error
keymap("n", "[E", function()
	require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
keymap("n", "]E", function()
	require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
end)

-- Toggle outline
keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>")

-- Hover Doc
-- If there is no hover doc,
-- there will be a notification stating that
-- there is no information available.
-- To disable it just use ":Lspsaga hover_doc ++quiet"
-- Pressing the key twice will enter the hover window
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")

-- If you want to keep the hover window in the top right hand corner,
-- you can pass the ++keep argument
-- Note that if you use hover with ++keep, pressing this key again will
-- close the hover window. If you want to jump to the hover window
-- you should use the wincmd command "<C-w>w"
keymap("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")

-- Call hierarchy
keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

-- Floating terminal
keymap({ "n", "t" }, "<leader>[", "<cmd>Lspsaga term_toggle<CR>")

-- bufferline
keymap("n", "<S-Tab>", "<cmd> BufferLineCyclePrev <CR>")
keymap("n", "<TAB>", "<cmd> BufferLineCycleNext <CR>")

--  -- restart lsp server (not on youtube nvim video)
keymap("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary

-- trouble by folke
keymap("n", "<leader>xx", "<cmd>TroubleToggle<CR>")
keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>")
keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>")
keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<CR>")
keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>")
keymap("n", "gR", "<cmd>TroubleToggle lsp_references<CR>")
--todo comment
keymap("n", "<leader>tm", "<cmd>TodoTelescope<CR>")
keymap("n", "<leader>tx", "<cmd>TodoTrouble<CR>")
keymap("n", "<leader>tl", "<cmd>TodoLocList<CR>")
keymap("n", "<leader>tq", "<cmd>TodoQuickFix<CR>")
-- inc-rename to rename variables
-- keymap("n", "<space>r", ":IncRename")

-- FLUTTER KEYMAPS
-- Run the current project
keymap("n", "<leader>yr", ":FlutterRun<CR>")
-- Brings up a list of connected devices to select from
keymap("n", "<leader>yd", ":FlutterDevices<CR>")
-- Sikilar to devices but shows a list of emulators to choose from
keymap("n", "<leader>ye", ":FlutterEmulators<CR>")
-- Ends a running session
keymap("n", "<leader>yq", ":FlutterQuit<CR>")
-- flutter outline
keymap("n", "<leader>yo", ":FlutterOutlineOpen<CR>")
-- flutter restart
keymap("n", "<leader>ys", ":FlutterRestart<CR>")
-- flutter fvm integration with Telescope
keymap("n", "<leader>yv", ":Telescope flutter fvm<CR>")

-- LUA SNIPPETS
-- be careful
keymap(
	"n",
	"<leader>us",
	"<cmd>lua require('luasnip.loaders').edit_snippet_files() <CR>",
	{ noremap = true, silent = true }
)

-- notify
keymap("n", "<leader>un", function()
	require("notify").dismiss({ silent = true, pending = true })
end, {
	desc = "Delete all notifications",
})

-- debuggin
keymap("n", "<leader>dL", function()
	require("dap").set_breakpoint(nil, nil, fn.input("Log point message: "))
end, { desc = "Dap: Log breakpoint" })

keymap("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "Dap: toggle breakpoint" })

keymap("n", "<leader>dB", function()
	require("dap").set_breakpoint(fn.input("Breakpoint condition: "))
end, { desc = "Dap: set conditional breakpoint" })

keymap("n", "<leader>dc", function()
	require("dap").set_breakpoint(fn.input("Breakpoint condition: "))
end, { desc = "Dap: continue or start debuggin " })

keymap("n", "<leader>duc", function()
	require("dapui").close(as.debug.layout.ft[vim.bo.ft])
end, { desc = "Dap ui: close " })

keymap("n", "<leader>dut", function()
	require("dapui").toggle(as.debug.layout.ft[vim.bo.ft])
end, { desc = "Dap ui: toggle " })

keymap("n", "<localleader>de", function()
	require("dap").step_out()
end, { desc = "dap: step out" })
keymap("n", "<localleader>di", function()
	require("dap").step_into()
end, { desc = "dap: step into" })
keymap("n", "<localleader>do", function()
	require("dap").step_over()
end, { desc = "dap: step over" })
keymap("n", "<localleader>dl", function()
	require("dap").run_last()
end, { desc = "dap REPL: run last" })
