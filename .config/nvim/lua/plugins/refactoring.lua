return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"lewis6991/async.nvim",
	},
	config = function()
		require("refactoring").setup({})
		pcall(function()
			require("telescope").load_extension("refactoring")
		end)
	end,
}
