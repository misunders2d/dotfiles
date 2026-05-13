require("yazi").setup({
	open_for_directories = true,
	open_multiple_tabs = true,
	keymaps = {
		show_help = "<f1>",
	},
})

vim.keymap.set("n", "<leader>-", "<cmd>Yazi<cr>", { desc = "Open Yazi" })
vim.keymap.set("n", "<leader>gw", "<cmd>Yazi toggle<cr>", { desc = "Resume Yazi" })
