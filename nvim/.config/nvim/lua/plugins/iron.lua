local iron = require("iron.core")
local view = require("iron.view")
local common = require("iron.fts.common")

iron.setup({
	config = {
		scratch_repl = true,
		repl_definition = {
			python = {
				command = { "ipython", "--no-autoindent" },
				format = common.bracketed_paste_python,
			},
			sh = { command = { "bash" } },
		},
		repl_open_cmd = view.split.vertical.botright(0.4),
	},
	keymaps = {
		send_motion = "<leader>sc",
		visual_send = "<leader>sc",
		send_file = "<leader>sF",
		send_line = "<leader>sl",
		send_paragraph = "<leader>sp",
		send_until_cursor = "<leader>su",
		send_mark = "<leader>sm",
		mark_motion = "<leader>smc",
		mark_visual = "<leader>smc",
		remove_mark = "<leader>smd",
		cr = "<leader>s<cr>",
		interrupt = "<leader>s<space>",
		exit = "<leader>sQ",
		clear = "<leader>cl",
	},
	highlight = { italic = true },
	ignore_blank_lines = true,
})

vim.keymap.set("n", "<leader>rs", "<cmd>IronRepl<cr>", { desc = "Open/toggle REPL" })
vim.keymap.set("n", "<leader>rr", "<cmd>IronRestart<cr>", { desc = "Restart REPL" })
vim.keymap.set("n", "<leader>rf", "<cmd>IronFocus<cr>", { desc = "Focus REPL" })
vim.keymap.set("n", "<leader>rh", "<cmd>IronHide<cr>", { desc = "Hide REPL" })
