return {
	{
		"milanglacier/minuet-ai.nvim",
		config = function()
			require("minuet").setup({
				virtualtext = {
					auto_trigger_ft = {},
					keymap = {
						accept = "<A-A>",
						accept_line = "<A-a>",
						accept_n_lines = "<A-z>",
						prev = "<A-[>",
						next = "<A-]>",
						dismiss = "<A-e>",
					},
				},
				provider = "gemini",
				provider_options = {
					gemini = {
						model = "gemini-2.5-flash",
						api_key = "GEMINI_API_KEY",
						end_point = "https://generativelanguage.googleapis.com/v1beta/models",
						stream = true,
					},
				},
				throttle = 2000,
				debounce = 400,
			})
		end,
	},
	{ "nvim-lua/plenary.nvim" },
	{
		"saghen/blink.cmp",
		optional = true,
		enabled = true,
		version = "1.*",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"milanglacier/minuet-ai.nvim",
			"saghen/blink.compat",
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			snippets = {
				preset = "luasnip",
			},
			sources = {
				default = { "lsp", "path", "buffer", "snippets", "minuet" },
				providers = {
					minuet = {
						name = "minuet",
						module = "minuet.blink",
						score_offset = 8,
					},
				},
			},
			completion = { trigger = { prefetch_on_insert = false } },
		},
	},
}
