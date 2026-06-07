vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.10.2" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/mikavilpas/yazi.nvim" },
	{ src = "https://github.com/akinsho/bufferline.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/yetone/avante.nvim" },
	{ src = "https://github.com/olimorris/codecompanion.nvim" },
	{ src = "https://github.com/Vigemus/iron.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/sindrets/diffview.nvim" },
	{ src = "https://github.com/NeogitOrg/neogit" },
})

require("plugins.tokyonight")
require("plugins.snacks")
require("plugins.blink")
require("plugins.treesitter")
require("plugins.lazydev")
require("plugins.lsp")
require("plugins.conform")
require("plugins.yazi")
require("plugins.bufferline")
require("plugins.avante")
require("plugins.codecompanion")
require("plugins.codex_inline")
require("plugins.iron")
require("plugins.gitsigns")
require("plugins.diffview")
require("plugins.neogit")
