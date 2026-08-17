vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	group = vim.api.nvim_create_augroup("user-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Add project roots to file lookup",
	group = vim.api.nvim_create_augroup("user-project-path", { clear = true }),
	pattern = "*",
	callback = function(args)
		local root = vim.fs.root(
			args.buf,
			{ ".git", "pyproject.toml", "package.json", "Cargo.toml", "go.mod", "setup.py", "setup.cfg" }
		)
		if not root then
			return
		end

		vim.opt_local.path:append(root)
		local src = vim.fs.joinpath(root, "src")
		local stat = vim.uv.fs_stat(src)
		if stat and stat.type == "directory" then
			vim.opt_local.path:append(src)
		end
	end,
})
