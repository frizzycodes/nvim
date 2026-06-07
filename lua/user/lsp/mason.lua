local handlers = require("user.lsp.handlers")

local servers = {
	lua_ls = {},
	clangd = {},
	pyright = {},
	jsonls = {},

	-- extras
	gopls = {},
	bashls = {},
	html = {},
	cssls = {},
	yamlls = {},
}

require("mason").setup({
	ui = {
		border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
})

require("mason-lspconfig").setup({
	ensure_installed = vim.tbl_keys(servers),
	automatic_installation = true,
})

-- Global defaults inherited by all servers
vim.lsp.config("*", {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
})

-- Per-server overrides
for server, opts in pairs(servers) do
	local ok, custom =
		pcall(require, "user.lsp.settings." .. server)

	if ok then
		opts = vim.tbl_deep_extend("force", opts, custom)
	end

	vim.lsp.config(server, opts)
end

-- Enable all servers
for server, _ in pairs(servers) do
	vim.lsp.enable(server)
end
