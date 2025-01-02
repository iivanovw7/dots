-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local lspconfig = require("lspconfig")
local actions = require("diffview.actions")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
  end,
})

require("tabnine.status").status()

require("diffview").setup({
  diff_binaries = false,
  enhanced_diff_hl = false,
  git_cmd = { "git" },
  hg_cmd = { "hg" },
  use_icons = true,
  show_help_hints = true,
  watch_index = true,
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

require("luasnip.loaders.from_vscode").lazy_load()

require("convert").setup({
  keymaps = {
    focus_next = { "j", "<Down>", "<Tab>" },
    focus_prev = { "k", "<Up>", "<S-Tab>" },
    close = { "<Esc>", "<C-c>", "qq" },
    submit = { "<CR>", "<Space>" },
  },
})
