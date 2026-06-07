require("gitsigns").setup({
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	current_line_blame = false,
	on_attach = function(bufnr)
		local gs = require("gitsigns")
		local map = vim.keymap.set

		local function opts(desc)
			return { buffer = bufnr, desc = desc }
		end

		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gs.nav_hunk("next")
			end
		end, opts("Next git hunk"))

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gs.nav_hunk("prev")
			end
		end, opts("Prev git hunk"))

		map("n", "<leader>hs", gs.stage_hunk, opts("Stage hunk"))
		map("n", "<leader>hr", gs.reset_hunk, opts("Reset hunk"))
		map("v", "<leader>hs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, opts("Stage selected hunk"))
		map("v", "<leader>hr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, opts("Reset selected hunk"))
		map("n", "<leader>hS", gs.stage_buffer, opts("Stage buffer"))
		map("n", "<leader>hR", gs.reset_buffer, opts("Reset buffer"))
		map("n", "<leader>hp", gs.preview_hunk, opts("Preview hunk"))
		map("n", "<leader>hb", function()
			gs.blame_line({ full = true })
		end, opts("Blame line"))
		map("n", "<leader>htb", gs.toggle_current_line_blame, opts("Toggle line blame"))
		map("n", "<leader>hd", gs.diffthis, opts("Diff against index"))
		map("n", "<leader>hD", function()
			gs.diffthis("~")
		end, opts("Diff against last commit"))

		map({ "o", "x" }, "ih", gs.select_hunk, opts("Select hunk (text object)"))
	end,
})
