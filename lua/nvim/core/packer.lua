local cmd = vim.cmd
-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local options = {
	auto_clean = true,
	compile_on_sync = true,
	git = { clone_timeout = 6000 },
	display = {
		working_sym = "ﲊ",
		error_sym = "✗ ",
		done_sym = " ",
		removed_sym = " ",
		moved_sym = "",
		open_fn = function()
			return require("packer.util").float({ border = "single" })
		end,
	},
}
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

packer.init(options)

-- add list of plugins to install
return packer.startup(function(use)
	-- packer can manage itself
	use("wbthomason/packer.nvim")

	use("nvim-lua/plenary.nvim") -- lua functions that many plugins use
	use("folke/tokyonight.nvim") -- tokyonight theme

	use({ "catppuccin/nvim", as = "catppuccin" }) -- catpuccin

	-- use("bluz71/vim-nightfly-guicolors") -- preferred colorscheme

	-- use("christoomey/vim-tmux-navigator") -- tmux & split window navigation

	-- use("szw/vim-maximizer") -- maximizes and restores current window

	-- essential plugins
	--  surround
	use({
		"echasnovski/mini.surround",
		branch = "stable",
	})
	-- use("tpope/vim-surround") -- add, delete, change surroundings (it's awesome)
	-- use("inkarkat/vim-ReplaceWithRegister") -- replace with register contents using motion (gr + motion)

	-- commenting with gc
	use("numToStr/Comment.nvim")

	-- file explorer
	use("nvim-tree/nvim-tree.lua")

	-- vs-code like icons
	use("nvim-tree/nvim-web-devicons")

	-- statusline
	-- use("hoob3rt/lualine.nvim")
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})

	-- fuzzy finding w/ telescope
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder
	-- PLUGINS FOR CODING
	-- autocompletion
	use({
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
		},
	}) -- completion plugin

	-- references
	use({ "RRethy/vim-illuminate" })

	use("hrsh7th/cmp-buffer") -- source for text in buffer
	use("hrsh7th/cmp-path") -- source for file system paths
	use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
	-- use("saadparwaiz1/cmp_luasnip") -- for autocompletion

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- managing & installing lsp servers, linters & formatters
	use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig

	-- configuring lsp servers
	use("neovim/nvim-lspconfig") -- easily configure language servers

	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
		requires = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	}) -- enhanced lsp uis

	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
	use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

	-- formatting & linting
	use("jose-elias-alvarez/null-ls.nvim") -- configure formatters & linters
	use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls

	-- treesitter configuration
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	--bufferline
	use({
		"akinsho/bufferline.nvim",
		tag = "v3.*",
		requires = { "nvim-tree/nvim-web-devicons" },
	})

	-- auto pairs
	use({
		"echasnovski/mini.pairs",
		branch = "stable",
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	})
	-- autoclose tags
	-- auto closing
	-- use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- git integration
	use("tpope/vim-fugitive") -- show line modifications on left hand side
	use("tpope/vim-rhubarb") -- show line modifications on left hand side
	use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

	use({
		"yamatsum/nvim-nonicons",
		requires = { "kyazdani42/nvim-web-devicons" },
	})
	use("psliwka/vim-smoothie")
	-- html/react
	use("alvan/vim-closetag")
	-- use("andrewRadev/tagalong.vim")

	-- flutter plugins
	use({
		"akinsho/flutter-tools.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
	})
	---------------------------------------------------------------------------------
	-- Personal plugins akinsho {{{1
	-----------------------------------------------------------------------------//
	use({
		"akinsho/pubspec-assist.nvim",
		requires = "plenary.nvim",
		config = function()
			require("pubspec-assist").setup()
		end,
	})

	use({
		"akinsho/git-conflict.nvim",
		tag = "*",
		config = function()
			require("git-conflict").setup()
		end,
	})
	-- colorier for tailwindcss
	use({
		"roobert/tailwindcss-colorizer-cmp.nvim",
		-- optionally, override the default options:
		config = function()
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 2,
			})
		end,
	})
	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				"*", -- Highlight all files, but customize some others.
				css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
			})
		end,
	})
	-- Database
	-- use({ "tpope/vim-dadbod" })
	-- use({ "kristijanhusak/vim-dadbod-ui" })

	-- trouble
	use({ "folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons" })
	-- tood comment
	use({ "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" })
	-- line indent
	use("lukas-reineke/indent-blankline.nvim")
	-- to rename variables
	-- use({
	-- 	"smjonas/inc-rename.nvim",
	-- 	config = function()
	-- 		require("inc_rename").setup()
	-- 	end,
	-- })
	-- status line search
	-- use("b0o/incline.nvim")
	-- friendly-snippets
	-- use("rafamadriz/friendly-snippets")
	-- Packer
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

	-- which key
	use({
		"folke/which-key.nvim",
	})
	-- ui
	use({
		"rcarriga/nvim-notify",
	})
	-- dressing
	use({
		"stevearc/dressing.nvim",
	})
	-- display for cmd
	use({
		"folke/noice.nvim",
		requires = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	})
	-- for status line
	use({
		"SmiteshP/nvim-navic",
		requires = "neovim/nvim-lspconfig",
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
