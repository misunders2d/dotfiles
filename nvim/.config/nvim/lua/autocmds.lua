vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	group = vim.api.nvim_create_augroup("user-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Rebuild avante.nvim after install/update",
	group = vim.api.nvim_create_augroup("user-pack-build", { clear = true }),
	callback = function(args)
		local data = args.data
		if not (data and data.spec and data.spec.name == "avante.nvim") then
			return
		end
		if data.kind ~= "install" and data.kind ~= "update" then
			return
		end
		vim.notify("Building avante.nvim…", vim.log.levels.INFO)
		vim.system({ "make" }, { cwd = data.path }, function(out)
			vim.schedule(function()
				if out.code == 0 then
					vim.notify("avante.nvim build complete", vim.log.levels.INFO)
				else
					vim.notify("avante.nvim build failed:\n" .. (out.stderr or ""), vim.log.levels.ERROR)
				end
			end)
		end)
	end,
})
