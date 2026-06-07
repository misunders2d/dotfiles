local codex_acp = vim.fn.expand("~/.cargo/bin/codex-acp")

require("codecompanion").setup({
	adapters = {
		acp = {
			codex = function()
				return require("codecompanion.adapters").extend("codex", {
					commands = {
						default = { codex_acp },
					},
					defaults = {
						-- Use Codex/ChatGPT subscription auth, not OpenAI API keys.
						auth_method = "chatgpt",
						timeout = 60000,
					},
				})
			end,
		},
	},
	interactions = {
		-- ACP works for chat/agent sessions. CodeCompanion inline is HTTP-only,
		-- so inline edits are handled by plugins.codex_inline via `codex exec`.
		chat = {
			adapter = "codex",
		},
	},
})

vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", {
	desc = "CodeCompanion chat",
})
vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", {
	desc = "CodeCompanion actions",
})
