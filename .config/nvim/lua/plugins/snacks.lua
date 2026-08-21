return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			explorer = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			image = { enabled = true },
			toggle = { enabled = true },
			git = { enabled = true },
			picker = {
				actions = {
					expand_explorer = function(picker)
						local win = vim.api.nvim_get_current_win()

						if not picker._explorer_original_width then
							picker._explorer_original_width = vim.api.nvim_win_get_width(win)
						end

						if picker._explorer_expanded then
							vim.api.nvim_win_set_width(win, picker._explorer_original_width)

							picker._explorer_expanded = false
							return
						end

						local item = picker:current()
						if not item then
							return
						end

						local path = item.file or item.text or ""
						local filename = vim.fn.fnamemodify(path, ":t")

						local wanted_width = vim.fn.strdisplaywidth(filename) + 30

						vim.api.nvim_win_set_width(win, wanted_width)
						picker._explorer_expanded = true
					end,

					explorer = {
						desc = "Expand Explorer",
					},
				},
				enabled = true,
				sources = {
					explorer = {
						hidden = false,
						ignored = false,
						exclude = {
							".git",
						},
						win = {
							list = {
								keys = {
									["e"] = {
										"expand_explorer",
										mode = { "n", "x" },
										desc = "Expand Explorer to filename",
									},
								},
							},
						},
					},
				},
			},
			notifier = { enabled = true },
			quickfile = { enabled = true },
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
