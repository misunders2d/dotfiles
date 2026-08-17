local parsers = {
	"bash",
	"c",
	"diff",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"rust",
	"toml",
	"typescript",
	"tsx",
	"yaml",
	"vim",
	"vimdoc",
}

require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})
require("nvim-treesitter").install(parsers)

vim.api.nvim_create_autocmd("FileType", {
	pattern = vim.list_extend({ "javascriptreact", "typescriptreact" }, parsers),
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})
