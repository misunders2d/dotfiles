require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua-language-server",
		"pyright",
		"typescript-language-server",
		"rust-analyzer",
		"bash-language-server",
		"stylua",
		"ruff",
		"prettier",
		"shfmt",
		"shellcheck",
	},
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
				showWord = "Disable",
				workspaceWord = false,
			},
		},
	},
})

vim.lsp.config("pyright", {})
vim.lsp.config("ts_ls", {})

vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true },
			checkOnSave = { command = "clippy" },
		},
	},
})

vim.lsp.config("bashls", {})

vim.lsp.enable({ "lua_ls", "pyright", "ts_ls", "rust_analyzer", "bashls" })

vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
	virtual_text = {
		source = "if_many",
		spacing = 2,
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		-- Completion UI is handled by blink.cmp.
		-- Do not also enable built-in LSP completion, or two menus can compete.
		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			vim.keymap.set("n", "<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, { buffer = event.buf, desc = "Toggle inlay hints" })
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local hl_group = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = hl_group,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = hl_group,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})
