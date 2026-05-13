require("avante").setup({
	provider = "openrouter",
	input = { provider = "snacks" },
	selector = { provider = "snacks" },
	providers = {
		openrouter = {
			__inherited_from = "openai",
			endpoint = "https://openrouter.ai/api/v1",
			api_key_name = "OPENROUTER_API_KEY",
			model = "anthropic/claude-sonnet-4-6",
		},
		deepseek = {
			__inherited_from = "openai",
			endpoint = "https://api.deepseek.com/v1",
			api_key_name = "DEEPSEEK_API_KEY",
			model = "deepseek-chat",
		},
	},
})
