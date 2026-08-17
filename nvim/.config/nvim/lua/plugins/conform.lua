require("conform").setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		local disable = { c = true, cpp = true }
		if disable[vim.bo[bufnr].filetype] then
			return nil
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		python = { "ruff_organize_imports", "ruff_format" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		rust = { lsp_format = "prefer" },
		sh = { "shfmt" },
		bash = { "shfmt" },
	},
})

vim.keymap.set("", "<leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
