return {
	{
		"rafamadriz/friendly-snippets",
		{
			"saghen/blink.compat",
			optional = true,
			opts = {},
			version = not vim.g.lazyvim_blink_main and "*",
			build = "make install_jsregexp" or nil,
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = { vim.fn.expand("~/.config/nvim/lua/snippets") },
			})
		end,
	},
}
