local codex_acp = vim.fn.expand("~/.local/bin/codex-acp")

require("codecompanion").setup({
	adapters = {
		acp = {
			codex = function()
				return require("codecompanion.adapters").extend("codex", {
					commands = {
						default = { codex_acp },
					},
					env = {
						CODEX_HOME = vim.fn.expand("~/.config/codecompanion-codex"),
						INITIAL_AGENT_MODE = "agent",
					},
					defaults = {
						-- Use Codex/ChatGPT subscription auth, not OpenAI API keys.
						auth_method = "chat-gpt",
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
