local status_ok, ibl = pcall(require, "ibl")
if not status_ok then
	return
end

-- HACK: work-around for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
vim.wo.colorcolumn = "99999"

ibl.setup({
	indent = {
		char = "▏",
	},
	scope = {
		enabled = true,
	},
	exclude = {
		buftypes = { "terminal", "nofile" },
		filetypes = {
			"help",
			"startify",
			"dashboard",
			"lazy",
			"neogitstatus",
			"NvimTree",
			"Trouble",
		},
	},
})
