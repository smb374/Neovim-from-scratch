local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use {
    "wbthomason/packer.nvim",
    opt = true,
  }
  use "nvim-lua/popup.nvim"
  use "nvim-lua/plenary.nvim"
  use {
    "windwp/nvim-autopairs",
    after = "nvim-cmp",
    config = [[require("user.autopairs")]]
  }
  use {
    "numToStr/Comment.nvim",
    module = "Comment",
    keys = { "gc", "gcc", "gbc" },
    config = [[require("user.comment")]],
  }
  use {
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function ()
      require("nvim-web-devicons").setup({default = true})
    end
  }
  use {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = [[require("user.nvim-tree")]]
  }
  use {
    "akinsho/bufferline.nvim",
    event = "BufReadPre",
    requires = "kyazdani42/nvim-web-devicons",
    config = [[require("user.bufferline")]]
  }
  use {
    "moll/vim-bbye",
    cmd = { "Bdelete", "Bwipeout" },
  }
  use {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    wants = "nvim-web-devicons",
    config = [[require("user.lualine")]]
  }
  use {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    config = [[require("user.toggleterm")]]
  }
  use {
    "ahmedkhalf/project.nvim",
    event = "VimEnter",
    config = [[require("user.project")]],
  }
  use "lewis6991/impatient.nvim"
  use {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = [[require("user.indentline")]]
  }
  use {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = [[require("user.alpha")]]
  }
  use "antoinemadec/FixCursorHold.nvim"
  use {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = [[require("user.whichkey")]]
  }
  use {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    requires = "kyazdani42/nvim-web-devicons",
    config = [[require("user.diag")]],
  }
  use {
    "norcalli/nvim-colorizer.lua",
    config = function ()
      require("colorizer").setup()
    end
  }

  -- Colorschemes
  use {
    "folke/tokyonight.nvim",
    config = function ()
      local g = vim.g
      g.tokyonight_style = "night"
      g.tokyonight_italic_functions = true
      g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

      vim.cmd([[colorscheme tokyonight]])
    end
  }
  -- use {
  --   "rmehri01/onenord.nvim",
  --   config = function ()
  --     require('onenord').setup({
  --       theme = "dark",
  --       styles = {
  --         comments = "italic",
  --         strings = "NONE",
  --         keywords = "italic",
  --         functions = "italic",
  --         variables = "NONE",
  --         diagnostics = "underline",
  --       },
  --     })
  --   end
  -- }

  -- cmp plugins
  use {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = [[require("user.cmp")]]
  }
  use {
    "hrsh7th/cmp-buffer",
    after = "nvim-cmp",
  }
  use {
    "hrsh7th/cmp-path",
    after = "nvim-cmp",
  }
  use {
    "hrsh7th/cmp-cmdline",
    after = "nvim-cmp",
  }
  use {
    "saadparwaiz1/cmp_luasnip",
    after = "nvim-cmp",
  }
  use {
    "hrsh7th/cmp-nvim-lsp",
    module = "cmp_nvim_lsp",
  }
  use {
    "hrsh7th/cmp-nvim-lua",
    after = "nvim-cmp",
  }

  -- snippets
  use {
    "L3MON4D3/LuaSnip",
    wants = "friendly-snippets",
    after = "nvim-cmp",
  }
  use {
    "rafamadriz/friendly-snippets",
    after = "nvim-cmp",
  }

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    config = [[require("user.lsp")]],
    requires = {
      {
        "williamboman/nvim-lsp-installer",
        module = "nvim-lsp-installer",
        cmd = {
          "LspInstall",
          "LspInstallInfo",
          "LspUninstall",
          "LspUninstallAll",
          "LspInstallLog",
        },
      },
      {
        "tamago324/nlsp-settings.nvim",
        after = "nvim-lspconfig",
      },
      {
        "jose-elias-alvarez/null-ls.nvim",
        module = "null-ls",
      },
    },
  }
  use {
    "folke/lsp-colors.nvim",
    after = "nvim-lspconfig",
    config = function ()
      require("lsp-colors").setup()
    end
  }

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    module = "telescope",
    config = [[require("user.telescope")]]
  }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    config = [[require("user.treesitter")]],
    run = ":TSUpdate",
  }
  use {
    "nvim-treesitter/playground",
    after = "nvim-treesitter"
  }
  use {
    "JoosepAlviste/nvim-ts-context-commentstring",
    after = "nvim-treesitter"
  }

  -- Git
  use {
    "lewis6991/gitsigns.nvim",
    event = "VimEnter",
    config = [[require("user.gitsigns")]]
  }
  use {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig" },
  }

  -- Markdown
  use {
    "davidgranstrom/nvim-markdown-preview",
  }

  -- OrgMode
  use {
    "nvim-orgmode/orgmode",
    wants = "nvim-treesitter",
    config = function ()
      require("orgmode").setup()
    end
  }

  -- Mini.nvim
  use {
    "echasnovski/mini.nvim",
    tag = "v0.3.0",
    config = function ()
      -- Enable Surround
      require("user.surround")
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
