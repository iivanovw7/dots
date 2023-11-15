-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local lspconfig = require('lspconfig')
local actions = require('diffview.actions')
local dracula = require("dracula")

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }

    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)

  end,
})

require("tabnine").setup({
    disable_auto_comment=true,
    accept_keymap="<Tab>",
    dismiss_keymap = "<C-]>",
    debounce_ms = 800,
    suggestion_color = {gui = "#e8e8e8", cterm = 244},
    run_on_every_keystroke = true,
    exclude_filetypes = {"TelescopePrompt", "NvimTree"},
    log_file_path = nil, -- absolute path to Tabnine log file
})

require('tabnine.status').status()

require("diffview").setup({
    diff_binaries = false,    -- Show diffs for binaries
    enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
    git_cmd = { "git" },      -- The git executable followed by default args.
    hg_cmd = { "hg" },        -- The hg executable followed by default args.
    use_icons = true,         -- Requires nvim-web-devicons
    show_help_hints = true,   -- Show hints for how to open the help panel
    watch_index = true,       -- Update views and index buffers when the git index changes.
})

dracula.setup({
    colors = {
      bg = "#242631", -- "#282A36",
      fg = "#F8F8F2",
      selection = "#3b3e4f",
      comment = "#6272A4",
      red = "#FF5555",
      orange = "#FFB86C",
      yellow = "#F1FA8C",
      green = "#50fa7b",
      purple = "#BD93F9",
      cyan = "#8BE9FD",
      pink = "#FF79C6",
      bright_red = "#FF6E6E",
      bright_green = "#69FF94",
      bright_yellow = "#FFFFA5",
      bright_blue = "#D6ACFF",
      bright_magenta = "#FF92DF",
      bright_cyan = "#A4FFFF",
      bright_white = "#FFFFFF",
      menu = "#21222C",
      visual = "#3E4452",
      gutter_fg = "#4B5263",
      nontext = "#3B4048",
      white = "#ABB2BF",
      black = "#191A21",
    },
    show_end_of_buffer = true, -- default false
    lualine_bg_color = "#44475a", -- default nil
    italic_comment = true, -- default false
    overrides = {},
})

--vim.api.nvim_create_autocmd("BufReadPost", {
--  pattern = { "*" },
--  callback = function()
--    local filesize = vim.fn.getfsize(vim.fn.expand("%:p"))
--    if filesize < 1024 * 1024 then
--      return
--    end
--
--  vim.treesitter.stop()
--  end,
--})
