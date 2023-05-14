local opt = vim.opt -- for conciseness
local cmd = vim.cmd
local o = vim.o
-- Lua
cmd([[ autocmd!]])
cmd([[ set termguicolors]])
-- cmd([[
-- highlight Visual cterm=NONE ctermbg=236 ctermfg=NONE guibg=Grey40
-- ]])
-- cmd([[
-- highlight LineNr cterm=none ctermfg=240 guifg=#Grey40 guibg=#Grey40
-- ]])
-- vim.scriptencoding = "utf-8"
-- opt.encoding = "utf-8"
-- opt.fileencoding = "utf-8"
-- config mac
--cmd("set macmeta")
-- opt.spell = true
-- opt.spelllang = { "en_us" }
-- line numbers
-- opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

o.termguicolors = true
o.guifont = "CartographCF Nerd Font Mono:h14,codicon"
-- cursor pulse
opt.guicursor = {
	[[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]],
	[[a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor]],
	[[sm:block-blinkwait175-blinkoff150-blinkon175]],
}
-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
-- folding
-- Treesitter based folding
-- opt.foldlevel = 20
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = -1
opt.foldenable = true

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.iskeyword:append("-") -- consider string-string as whole word

-- Enable undercurls in terminal
-- Undercurl
cmd([[let &t_Cs = "\e[4:3m"]])
cmd([[let &t_Ce = "\e[4:0m"]])
