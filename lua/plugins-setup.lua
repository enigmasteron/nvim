-- auto install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- add list of plugins to install
return require('packer').startup(function(use)
  -- packer can manage itself
  use("wbthomason/packer.nvim")

  -- use {
  --   "williamboman/mason.nvim",
  --   config = function()
  --     require("mason").setup()
  --   end
  -- }

  use { 
    "nvim-telescope/telescope.nvim", branch = "0.1.x",
    -- require = {
    --   "nvim-telescope/telescope-fzf-native.nvim",
    -- },
  }

  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

  use("nvim-lua/plenary.nvim")

  use("ThePrimeagen/harpoon")

  use ({
    "eddyekofo94/gruvbox-flat.nvim",
    config = function()
      vim.cmd("colorscheme gruvbox-flat")
      vim.g.gruvbox_flat_style = "hard"
    end
  })

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

  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  }

  use("nvim-tree/nvim-tree.lua")

  use("nvim-tree/nvim-web-devicons")

  use {
    "nvim-lualine/lualine.nvim",
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox"
        }
      })
    end
  }

  use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"})
  use("nvim-treesitter/playground")
  use("nvim-treesitter/nvim-treesitter-context")

  use("github/copilot.vim")
end)