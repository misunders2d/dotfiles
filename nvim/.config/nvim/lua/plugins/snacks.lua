require("snacks").setup({
	picker = { enabled = true },
	bigfile = { enabled = true },
	quickfile = { enabled = true },
	notifier = { enabled = true },
	statuscolumn = { enabled = true },
	indent = { enabled = true },
})

local map = vim.keymap.set
local pick = function(name)
	return function()
		Snacks.picker[name]()
	end
end

map("n", "<leader>sf", pick("files"), { desc = "Search files" })
map("n", "<leader>sg", pick("grep"), { desc = "Search by grep" })
map("n", "<leader>sw", pick("grep_word"), { desc = "Search current word" })
map("n", "<leader>sb", pick("buffers"), { desc = "Buffers" })
map("n", "<leader>sh", pick("help"), { desc = "Help tags" })
map("n", "<leader>sk", pick("keymaps"), { desc = "Keymaps" })
map("n", "<leader>sd", pick("diagnostics"), { desc = "Diagnostics" })
map("n", "<leader>sr", pick("resume"), { desc = "Resume picker" })
map("n", "<leader>s.", pick("recent"), { desc = "Recent files" })
map("n", "<leader>sn", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Search nvim config" })
map("n", "<leader><leader>", pick("buffers"), { desc = "Find buffers" })
map("n", "<leader>/", pick("lines"), { desc = "Search lines in buffer" })
