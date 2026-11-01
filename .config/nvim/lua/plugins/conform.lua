return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        biome = {
          require_cwd = false,
        },
        djlint = {
          command = "djlint",
          args = { "--reformat", "-" },
        },
        stylelint = {
          command = "stylelint",
          args = { "--fix", "--stdin", "--stdin-filename", "$FILENAME" },
          stdin = true,
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        python = { "isort", "black" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "biome", "prettierd", "prettier", stop_after_first = false },
        javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = false },
        typescript = { "biome", "prettierd", "prettier", stop_after_first = false },
        typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = false },
        html = { "biome", "prettierd", "prettier", stop_after_first = false },
        htmldjango = { "prettierd", "prettier", stop_after_first = false },
        kotlin = { "ktlint" },
        tera = { "djlint", "prettierd" },
        css = { "prettier", "stylelint", stop_after_first = false },
        scss = { "prettier", "stylelint", stop_after_first = false },
        less = { "prettier", "stylelint", stop_after_first = false },
        sass = { "prettier", "stylelint", stop_after_first = false },
      },
    },
  },
}
