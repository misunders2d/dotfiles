local function clear_stale_yazi_winhighlight()
	local winhl = vim.wo.winhighlight
	if winhl:find("YaziBufferHovered", 1, true) then
		vim.wo.winhighlight = ""
	end
end

require("yazi").setup({
	open_for_directories = true,
	open_multiple_tabs = false,
	-- Avoid whole-window purple background highlights on normal editing buffers.
	highlight_hovered_buffers_in_same_directory = false,
	hooks = {
		yazi_closed_successfully = function()
			vim.schedule(clear_stale_yazi_winhighlight)
		end,
	},
	keymaps = {
		show_help = "<f1>",
	},
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	desc = "Clear stale yazi.nvim window highlights",
	group = vim.api.nvim_create_augroup("user-clear-yazi-winhighlight", { clear = true }),
	callback = clear_stale_yazi_winhighlight,
})

vim.keymap.set("n", "<leader>-", "<cmd>Yazi<cr>", { desc = "Open Yazi" })
vim.keymap.set("n", "<leader>gw", "<cmd>Yazi toggle<cr>", { desc = "Resume Yazi" })
