local M = {}

local function split_lines(text)
	text = text:gsub("\r\n", "\n")
	if text:sub(-1) == "\n" then
		text = text:sub(1, -2)
	end
	return vim.split(text, "\n", { plain = true })
end

local function selected_line_range()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local start_lnum = start_pos[2]
	local end_lnum = end_pos[2]

	if start_lnum == 0 or end_lnum == 0 then
		return nil
	end
	if start_lnum > end_lnum then
		start_lnum, end_lnum = end_lnum, start_lnum
	end
	return start_lnum, end_lnum
end

local function run_codex_inline(bufnr, start_lnum, end_lnum, user_prompt)
	local filename = vim.api.nvim_buf_get_name(bufnr)
	local filetype = vim.bo[bufnr].filetype
	local lines = vim.api.nvim_buf_get_lines(bufnr, start_lnum - 1, end_lnum, false)
	local selected = table.concat(lines, "\n")

	local schema_path = vim.fn.tempname() .. ".schema.json"
	local output_path = vim.fn.tempname() .. ".json"
	vim.fn.writefile({
		'{',
		'  "type": "object",',
		'  "properties": {',
		'    "replacement": { "type": "string" }',
		'  },',
		'  "required": ["replacement"],',
		'  "additionalProperties": false',
		'}',
	}, schema_path)

	local instruction = table.concat({
		"You are a Neovim inline code editor.",
		"Rewrite ONLY the selected code according to the user request.",
		"Return JSON only, matching the provided schema.",
		"Do not include Markdown, commentary, or surrounding file content.",
		"Preserve indentation style and keep the smallest correct change.",
		"",
		"File: " .. filename,
		"Filetype: " .. filetype,
		"",
		"Selected code:",
		"```" .. filetype,
		selected,
		"```",
		"",
		"User request:",
		user_prompt,
	}, "\n")

	vim.notify("Codex inline: working...", vim.log.levels.INFO, { title = "Codex Inline" })

	vim.system({
		"codex",
		"exec",
		"--skip-git-repo-check",
		"--ephemeral",
		"--sandbox",
		"read-only",
		"--output-schema",
		schema_path,
		"--output-last-message",
		output_path,
		"-",
	}, {
		text = true,
		stdin = instruction,
		cwd = vim.fn.getcwd(),
	}, function(result)
		vim.schedule(function()
			pcall(vim.fn.delete, schema_path)

			if result.code ~= 0 then
				pcall(vim.fn.delete, output_path)
				local msg = (result.stderr or result.stdout or "Codex failed"):gsub("%s+$", "")
				vim.notify(msg, vim.log.levels.ERROR, { title = "Codex Inline" })
				return
			end

			local raw = table.concat(vim.fn.readfile(output_path), "\n")
			pcall(vim.fn.delete, output_path)
			if raw == "" then
				raw = result.stdout or ""
			end

			local ok, decoded = pcall(vim.json.decode, raw)
			if not ok or type(decoded) ~= "table" or type(decoded.replacement) ~= "string" then
				vim.notify("Bad Codex inline JSON output: " .. raw, vim.log.levels.ERROR, { title = "Codex Inline" })
				return
			end

			vim.api.nvim_buf_set_lines(bufnr, start_lnum - 1, end_lnum, false, split_lines(decoded.replacement))
			vim.notify("Codex inline: applied. Use u to undo if wrong.", vim.log.levels.INFO, { title = "Codex Inline" })
		end)
	end)
end

function M.edit_visual()
	local bufnr = vim.api.nvim_get_current_buf()
	local start_lnum, end_lnum = selected_line_range()
	if not start_lnum then
		vim.notify("Select code first, then press <leader>ci", vim.log.levels.WARN, { title = "Codex Inline" })
		return
	end

	vim.ui.input({ prompt = "Codex inline edit: " }, function(input)
		if not input or input == "" then
			return
		end
		run_codex_inline(bufnr, start_lnum, end_lnum, input)
	end)
end

function M.edit_current_line()
	local bufnr = vim.api.nvim_get_current_buf()
	local line = vim.api.nvim_win_get_cursor(0)[1]
	vim.ui.input({ prompt = "Codex inline edit current line: " }, function(input)
		if not input or input == "" then
			return
		end
		run_codex_inline(bufnr, line, line, input)
	end)
end

vim.keymap.set("n", "<leader>ci", M.edit_current_line, { desc = "Codex inline edit current line" })
vim.keymap.set("v", "<leader>ci", function()
	vim.cmd("normal! \27")
	M.edit_visual()
end, { desc = "Codex inline edit selection" })

return M
