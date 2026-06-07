-- Skip the deprecated nvim-treesitter module for ts_context_commentstring
vim.g.skip_ts_context_commentstring_module = true

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  ensure_installed = { "lua", "markdown", "markdown_inline", "bash", "python" }, -- put the language you want in this array
  -- ensure_installed = "all", -- one of "all" or a list of languages
  ignore_install = { "" },                                                       -- List of parsers to ignore installing
  sync_install = false,                                                          -- install languages synchronously (only applied to `ensure_installed`)

  highlight = {
    enable = true,       -- false will disable the whole extension
    disable = { "css" }, -- list of language that will be disabled
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true, disable = { "python", "css" } },
}

-- Setup ts_context_commentstring separately (no longer an nvim-treesitter module)
require('ts_context_commentstring').setup {
  enable_autocmd = false,
}
