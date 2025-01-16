return {
  {
    "saghen/blink.cmp",
    optional = true,
    enabled = true,
    dependencies = { "tzachar/cmp-tabnine", "saghen/blink.compat" },
    opts = {
      snippets = {
        preset = "luasnip",
      },
      sources = {
        compat = { "cmp_tabnine" },
        providers = {
          cmp_tabnine = {
            kind = "TabNine",
            name = "cmp_tabnine",
            score_offset = -3,
            async = true,
            opts = {
              disable_auto_comment = false,
              accept_keymap = "<Tab>",
              dismiss_keymap = "<C-]>",
              debounce_ms = 800,
              suggestion_color = { gui = "#4C5259", cterm = 244 },
              run_on_every_keystroke = true,
              exclude_filetypes = { "TelescopePrompt", "NvimTree" },
              log_file_path = nil,
            },
          },
        },
      },
    },
  },
}
