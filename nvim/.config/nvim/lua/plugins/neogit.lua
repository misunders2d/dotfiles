require("neogit").setup({
	graph_style = "unicode",
	integrations = {
		diffview = true,
		snacks = true,
	},
})

local map = vim.keymap.set

map("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Neogit status" })
map("n", "<leader>gc", "<cmd>Neogit commit<CR>", { desc = "Neogit commit" })
map("n", "<leader>gp", "<cmd>Neogit pull<CR>", { desc = "Neogit pull" })
map("n", "<leader>gP", "<cmd>Neogit push<CR>", { desc = "Neogit push" })
map("n", "<leader>gb", "<cmd>Neogit branch<CR>", { desc = "Neogit branch" })
map("n", "<leader>gl", "<cmd>Neogit log<CR>", { desc = "Neogit log" })
