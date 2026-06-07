require("diffview").setup({
	enhanced_diff_hl = true,
	view = {
		merge_tool = {
			layout = "diff3_mixed",
			disable_diagnostics = true,
		},
	},
})

local map = vim.keymap.set

map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Diffview open" })
map("n", "<leader>gD", "<cmd>DiffviewClose<CR>", { desc = "Diffview close" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory<CR>", { desc = "Branch file history" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", { desc = "Current file history" })
