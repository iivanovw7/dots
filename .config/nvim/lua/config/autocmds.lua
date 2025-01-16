-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local lspconfig = require("lspconfig")
local actions = require("diffview.actions")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
  end,
})

require("tabnine.status").status()

require("diffview").setup({
  diff_binaries = false, -- Show diffs for binaries
  enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
  git_cmd = { "git" }, -- The git executable followed by default args.
  hg_cmd = { "hg" }, -- The hg executable followed by default args.
  use_icons = true, -- Requires nvim-web-devicons
  show_help_hints = true, -- Show hints for how to open the help panel
  watch_index = true, -- Update views and index buffers when the git index changes.
})

require("neogen").setup({
  enabled = true,
  languages = {
    typescriptreact = require("neogen.configurations.typescript"),
    javascriptreact = require("neogen.configurations.javascript"),
  },
})

require("guess-indent").setup({
  auto_cmd = true,
  override_editorconfig = false,
  filetype_exclude = {
    "netrw",
    "tutor",
  },
  buftype_exclude = {
    "help",
    "nofile",
    "terminal",
    "prompt",
  },
})

require("convert").setup({
  keymaps = {
    focus_next = { "j", "<Down>", "<Tab>" },
    focus_prev = { "k", "<Up>", "<S-Tab>" },
    close = { "<Esc>", "<C-c>", "qq" },
    submit = { "<CR>", "<Space>" },
  },
})
