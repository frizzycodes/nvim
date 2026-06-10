local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
	local config = {
		virtual_text = false, -- disable virtual text
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.HINT] = "",
				[vim.diagnostic.severity.INFO] = "",
			},
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = true,
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	-- Use global winborder for all floating windows (hover, signatureHelp, diagnostics)
	-- Replaces deprecated vim.lsp.with() handler overrides
	vim.o.winborder = "rounded"

	-- Global LspAttach autocommand to configure mappings and options
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			local bufnr = ev.buf
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if not client then
				return
			end

			-- Disable formatting if using ts_ls or lua_ls (fallback to null-ls/none-ls)
			if client.name == "ts_ls" or client.name == "lua_ls" then
				client.server_capabilities.documentFormattingProvider = false
			end

			-- Setup buffer-local keymaps
			local opts = { buffer = bufnr, silent = true }
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, opts)
			vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", opts)
			vim.keymap.set("n", "<leader>lI", "<cmd>Mason<cr>", opts)
			vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>lj", function() vim.diagnostic.jump({ count = 1 }) end, opts)
			vim.keymap.set("n", "<leader>lk", function() vim.diagnostic.jump({ count = -1 }) end, opts)
			vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, opts)

			-- Setup illuminate
			local status_ok, illuminate = pcall(require, "illuminate")
			if status_ok then
				illuminate.on_attach(client)
			end
		end,
	})
end

M.on_attach = function(client, bufnr)
	-- Handled globally via LspAttach autocmd in setup()
end

return M
