return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
			{ "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
			{ "stevearc/dressing.nvim", opts = {} },
		},
		enabled = true,
		config = function()
			require("codecompanion").setup({
				strategies = {
					chat = { adapter = "gemini" },
					inline = { adapter = "gemini" },
				},
				adapters = {
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							env = {
								model = "gemini-2.5-flash",
								api_key = "GEMINI_API_KEY",
								stream = true,
							},
						})
					end,
				},
			})
		end,
	},
}
