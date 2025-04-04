return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters = {
				biome = {
					require_cwd = false,
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
				kotlin = { "ktlint" },
			},
		},
	},
}
