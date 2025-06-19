-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	-- lua/plugins/rose-pine.lua
	use({
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			vim.cmd("colorscheme rose-pine")
		end,
	})
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("nvim-treesitter/playground")
	use("ThePrimeagen/harpoon")
	use("mbbill/undotree")
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
	})
	-- Using Packer:
	use("Mofiqul/dracula.nvim")
	use({ "ellisonleao/gruvbox.nvim" })
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("tpope/vim-fugitive")
	use("stevearc/conform.nvim")
	use({ "j-hui/fidget.nvim" }) -- use legacy tag if you're following Primeagen's older config

	use("wbthomason/packer.nvim") -- Packer manages itself

	-- LSP
	use("neovim/nvim-lspconfig") -- Core LSP config
	use({ -- Mason (LSP installer)
		"williamboman/mason.nvim",
		run = ":MasonUpdate", -- Optional
	})
	use("williamboman/mason-lspconfig.nvim") -- Bridges Mason and lspconfig

	-- Autocompletion core
	use("hrsh7th/nvim-cmp") -- Completion engine
	use("hrsh7th/cmp-nvim-lsp") -- LSP source for nvim-cmp
	use("hrsh7th/cmp-buffer") -- Buffer source
	use("hrsh7th/cmp-path") -- File system path source
	use("saadparwaiz1/cmp_luasnip") -- Luasnip completion source
	use("hrsh7th/cmp-cmdline") -- commandline completion

	-- Snippets
	use("L3MON4D3/LuaSnip") -- Snippet engine
	use("rafamadriz/friendly-snippets") -- Community snippet collection

	-- Optional UI: Add pretty icons (optional)
	use("onsails/lspkind.nvim") -- VS Code-like pictograms
	use({
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	use({
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<C-j>]],
				direction = "horizontal",
			})
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	})
	use("christoomey/vim-tmux-navigator")
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup()
		end,
	})

	use({
		"SmiteshP/nvim-navic",
		requires = "neovim/nvim-lspconfig",
	})
	use("wakatime/vim-wakatime")
	use("mattn/emmet-vim")
	--iron for jupyter
	use({
		"Vigemus/iron.nvim",
	})
	use("tpope/vim-dadbod")
	use("kristijanhusak/vim-dadbod-ui")
	use({
		"kristijanhusak/vim-dadbod-completion",
		ft = { "sql", "mysql", "plsql" },
		dependencies = {
			"hrsh7th/nvim-cmp",
			"tpope/vim-dadbod",
		},
		config = function()
			vim.g.db_completion_show_table_alias = 1
		end,
	})
	-- Using packer.nvim
	use({
		"ThePrimeagen/vim-apm",
	})
end)
