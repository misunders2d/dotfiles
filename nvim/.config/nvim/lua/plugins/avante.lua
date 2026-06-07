local function patch_avante_acp_inline_confirm()
	local ok_helpers, helpers = pcall(require, "avante.llm_tools.helpers")
	local ok_highlights, highlights = pcall(require, "avante.highlights")
	if not (ok_helpers and ok_highlights) then
		return
	end

	local default_permission_options = {
		{ optionId = "allow_always", name = "Allow Always", kind = "allow_always" },
		{ optionId = "allow_once", name = "Allow", kind = "allow_once" },
		{ optionId = "reject_once", name = "Reject", kind = "reject_once" },
	}

	local order = {
		allow_once = 1,
		allow_always = 2,
		reject_once = 3,
		reject_always = 4,
	}

	local function buttons_from_acp_options(options)
		local buttons = {}
		for _, item in ipairs(options or {}) do
			local icon = item.kind == "allow_once" and "" or ""
			if item.kind == "allow_always" then
				icon = ""
			end

			table.insert(buttons, {
				-- Avante's inline handler checks logical ids, but ACP providers
				-- like codex-acp send provider-specific optionId values.
				id = item.kind or item.optionId,
				name = item.name,
				icon = icon,
				hl = (item.kind == "reject_once" or item.kind == "reject_always")
					and highlights.BUTTON_DANGER_HOVER
					or nil,
				_order = order[item.kind] or 99,
			})
		end
		table.sort(buttons, function(a, b)
			return a._order == b._order and a.name < b.name or a._order < b._order
		end)
		for _, button in ipairs(buttons) do
			button._order = nil
		end
		return buttons
	end

	helpers.confirm_inline = function(callback, confirm_opts)
		local sidebar = require("avante").get()
		if not sidebar then
			callback("reject_once")
			return
		end

		confirm_opts = confirm_opts or {}
		local items = buttons_from_acp_options(confirm_opts.permission_options or default_permission_options)

		sidebar.permission_button_options = items
		sidebar.permission_handler = function(id)
			callback(id)
			sidebar.scroll = true
			sidebar.permission_button_options = nil
			sidebar.permission_handler = nil
			sidebar._history_cache_invalidated = true
			sidebar:update_content("")
		end
	end
end

require("avante").setup({
	provider = "codex",
	input = { provider = "snacks" },
	selector = { provider = "snacks" },
	acp_providers = {
		codex = {
			command = vim.fn.expand("~/.cargo/bin/codex-acp"),
			args = {},
			env = {
				NODE_NO_WARNINGS = "1",
				RUST_LOG = "off",
				CODEX_LOG_STDERR = "0",
				HOME = os.getenv("HOME"),
				PATH = os.getenv("PATH"),
				OPENAI_API_KEY = os.getenv("OPENAI_API_KEY"),
			},
		},
	},
	behaviour = {
		auto_approve_tool_permissions = false,
		auto_apply_diff_after_generation = false,
	},
	providers = {
		deepseek = {
			__inherited_from = "openai",
			endpoint = "https://openrouter.ai/api/v1",
			api_key_name = "OPENROUTER_API_KEY",
			model = "deepseek/deepseek-v4-flash",
			display_name = "OR · DeepSeek V4-flash",
			timeout = 60000,
			extra_request_body = {
				reasoning = { effort = "medium" },
			},
		},
	},
})

patch_avante_acp_inline_confirm()

vim.keymap.set("n", "<leader>aA", function()
	local cfg = require("avante.config").behaviour
	cfg.auto_approve_tool_permissions = not cfg.auto_approve_tool_permissions
	vim.notify(
		"Avante auto-approve: " .. tostring(cfg.auto_approve_tool_permissions),
		vim.log.levels.INFO
	)
end, { desc = "Toggle avante auto-approve" })
