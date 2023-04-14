local M = {}

function M.setup()
	-- Used to check if packer already installed.
	-- If first time installation, then restart nvim after install.
	local packer_bootstrap = false

	-- packer.nvim configuration
	local packer_config = {
		display = {
			open_fn = function()
				return require("packer.util").float { border = "rounded" }
			end,
		},
	}

	-- Check if packer.nvim is installed
	-- Run PackerCompile if there are no changes in this file
	local function ensure_packer()
		local fn = vim.fn
		local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
		if fn.empty(fn.glob(install_path)) > 0 then
			packer_bootstrap = fn.system {
				"git",
				"clone",
				"--depth",
				"1",
				"https://github.com/wbthomason/packer.nvim",
				install_path,
			}
			vim.cmd [[packadd packer.nvim]]
		end
		vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
	end

	-- Plugins
	local function plugins(use)
		-- Package manager
		use { "wbthomason/packer.nvim" }

		-- Theme
		use { "ellisonleao/gruvbox.nvim" }

		-- Ripgrep
		use {
		  'nvim-telescope/telescope.nvim', tag = '0.1.1',
		-- or                            , branch = '0.1.x',
		  requires = { {'nvim-lua/plenary.nvim'} }
		} 
		
		-- Syntax
		use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}

		-- LSP
		use {
		        'VonHeikemen/lsp-zero.nvim',
		        branch = 'v1.x',
		        requires = {

		      	  -- LSP Support
		      	  {'neovim/nvim-lspconfig'},
		      	  {'williamboman/mason.nvim'},
		      	  {'williamboman/mason-lspconfig.nvim'},

		      	  -- Autocompletion
		      	  {'hrsh7th/nvim-cmp'},
		      	  {'hrsh7th/cmp-buffer'},
		      	  {'hrsh7th/cmp-path'},
		      	  {'saadparwaiz1/cmp_luasnip'},
		      	  {'hrsh7th/cmp-nvim-lsp'},
		      	  {'hrsh7th/cmp-nvim-lua'},

		      	  -- Snippets
		      	  {'L3MON4D3/LuaSnip'},
		      	  {'rafamadriz/friendly-snippets'},
		        }
		}	

		-- Lets us know if we need to restart Neovim because first time installation
		-- of packer
		if packer_bootstrap then
			print "Restart Neovim required after installation!"
			require("packer").sync()
		end 
	end

	-- Call to make sure packer installed
	ensure_packer()

	local packer = require("packer")
	packer.init(packer_config)
	packer.startup(plugins)
end

return M 
