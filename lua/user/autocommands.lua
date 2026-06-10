local function create_augroup(name)
	return vim.api.nvim_create_augroup("_" .. name, { clear = true })
end

local general_settings_group = create_augroup("general_settings")
local git_group = create_augroup("git")
local markdown_group = create_augroup("markdown")
local auto_resize_group = create_augroup("auto_resize")
local alpha_group = create_augroup("alpha")

-- _general_settings
vim.api.nvim_create_autocmd("FileType", {
	group = general_settings_group,
	pattern = { "qf", "help", "man", "lspinfo" },
	callback = function()
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = general_settings_group,
	pattern = "*",
	callback = function()
		vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = general_settings_group,
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = general_settings_group,
	pattern = "qf",
	callback = function()
		vim.opt_local.buflisted = false
	end,
})

-- _git
vim.api.nvim_create_autocmd("FileType", {
	group = git_group,
	pattern = "gitcommit",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- _markdown
vim.api.nvim_create_autocmd("FileType", {
	group = markdown_group,
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- _auto_resize
vim.api.nvim_create_autocmd("VimResized", {
	group = auto_resize_group,
	pattern = "*",
	command = "tabdo wincmd =",
})

-- _alpha
vim.api.nvim_create_autocmd("User", {
	group = alpha_group,
	pattern = "AlphaReady",
	callback = function()
		vim.opt.showtabline = 0
		vim.api.nvim_create_autocmd("BufUnload", {
			buffer = 0,
			once = true,
			callback = function()
				vim.opt.showtabline = 2
			end,
		})
	end,
})
