return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			-- image = { enabled = true },
			explorer = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			picker = {
				enabled = true,
				sources = {
					explorer = {
						hidden = false,
						ignored = false,
						exclude = {
							".git",
						},
					},
				},
			},
			notifier = { enabled = true },
			quickfile = { enabled = true },
			toggle = { enabled = true },
			-- scope = { enabled = true },
			-- scroll = { enabled = true },
			statuscolumn = { enabled = true },
			-- words = { enabled = true },
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		enabled = false,
	},
}
