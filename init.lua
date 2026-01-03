-- Disable netrw (oil.nvim)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

require("options")
require("Lazy")
require("keymaps")
require("autocommands")
