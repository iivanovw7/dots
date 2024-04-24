-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<C-p>", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>1", function()
  ui.nav_file(1)
end)

vim.keymap.set("n", "<leader>2", function()
  ui.nav_file(2)
end)

vim.keymap.set("n", "<leader>3", function()
  ui.nav_file(3)
end)

vim.keymap.set("n", "<leader>4", function()
  ui.nav_file(4)
end)

vim.keymap.set("n", "<leader>5", function()
  ui.nav_file(5)
end)

vim.keymap.set("n", "<leader>6", function()
  ui.nav_file(6)
end)

vim.keymap.set("n", "<leader>5", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left>]])

vim.keymap.set("n", "<leader>6", "<cmd>Telescope undo<cr>")

local discipline = require("tool.discipline")

discipline.cowboy()

-- Delete a word backwards
-- vim.keymap.set("n", "dw", "vb_d")

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

-- Jumplist
vim.keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
vim.keymap.set("n", "te", ":tabedit<Return>", opts)
vim.keymap.set("n", "<tab>", ":tabnext<Return>", opts)
vim.keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- Split window
vim.keymap.set("n", "ss", ":split<Return>", opts)
vim.keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sl", "<C-w>l")

-- Resize window
vim.keymap.set("n", "<C-w><left>", "<C-w><")
vim.keymap.set("n", "<C-w><right>", "<C-w>>")
vim.keymap.set("n", "<C-w><up>", "<C-w>+")
vim.keymap.set("n", "<C-w><down>", "<C-w>-")

-- Diagnostics
vim.keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

vim.keymap.set("n", "<leader>r", function()
  require("tool.utils").replaceHexWithHSL()
end)

-- show documentation for what is under cursor
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

-- mapping to restart lsp if necessary
vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

-- neogen generate
vim.keymap.set(
  "n",
  "<Leader>nf",
  ":lua require('neogen').generate()<CR>",
  { noremap = true, silent = true, desc = "Neogen generate" }
)

vim.keymap.set(
  "n",
  "<leader>nq",
  "",
  { noremap = true, callback = require("tabnine.chat").open, desc = "Tabnine chat" }
)

-- Those are the default keymaps, you can change them to whatever you want
vim.api.nvim_set_keymap("n", "<leader>px", ":PxToRemCursor<CR>", { noremap = true, desc = "PxToRemCursor" })
vim.api.nvim_set_keymap("n", "<leader>pxl", ":PxToRemLine<CR>", { noremap = true, desc = "PxToRemLine" })

vim.api.nvim_set_keymap("n", "<leader>gd", ":DiffviewOpen", { noremap = true, desc = "Didffview open" })
vim.api.nvim_set_keymap("n", "<leader>gD", ":DiffviewClose", { noremap = true, desc = "Didffview close" })

vim.keymap.set("n", "<leader>no", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
