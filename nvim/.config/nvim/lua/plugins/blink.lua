require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 250,
		},
		menu = {
			auto_show = true,
		},
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = {
		implementation = "lua",
	},
})
