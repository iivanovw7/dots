-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.scrolloff = 8
-- vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- vim.opt.tabstop = 4
-- vim.opt.softtabstop = 4

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.fixeol = false

-- Disable mouse
-- vim.opt.mouse = ""

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

vim.g.snacks_animate = false
vim.g.lazyvim_blink_main = true
vim.g.lazyvim_prettier_needs_config = true
