require "user.impatient"
require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.colorscheme"
require "user.cmp"
require "user.lsp"
require "user.telescope"
require "user.gitsigns"
require "user.treesitter"
require "user.autopairs"
require "user.comment"
require "user.nvim-tree"
require "user.bufferline"
require "user.lualine"
require "user.toggleterm"
require "user.project"
require "user.indentline"
require "user.alpha"
require "user.whichkey"
require "user.autocommands"

vim.cmd("cd " .. vim.fn.expand("~"))
if vim.g.neovide then
    vim.g.neovide_scale_factor = 1.0

    local change_scale_factor = function(delta)
        vim.g.neovide_scale_factor =
            vim.g.neovide_scale_factor * delta
    end

    local modes = { "n", "i", "v", "c", "t" }

    vim.keymap.set(modes, "<C-=>", function()
        change_scale_factor(1.25)
    end)

    vim.keymap.set(modes, "<C-->", function()
        change_scale_factor(1 / 1.25)
    end)

    vim.keymap.set(modes, "<C-0>", function()
        vim.g.neovide_scale_factor = 1.0
    end)
end
