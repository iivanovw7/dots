return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			local ls = require("luasnip")
			local loader = require("luasnip.loaders.from_vscode")

			loader.lazy_load()
			loader.lazy_load({ paths = vim.fn.expand("~/.config/nvim/lua/snippets/react.tsx.json") })

			ls.config.set_config({
				history = true,
				updateevents = "TextChanged,TextChangedI",
			})
		end,
	},
}
