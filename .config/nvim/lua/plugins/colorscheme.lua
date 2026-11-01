return {
  "loctvl842/monokai-pro.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("monokai-pro").setup({
      transparent_background = true,
      terminal_colors = true,
      filter = "spectrum",
      devicons = true,
      inc_search = "background",
    })

    vim.cmd("colorscheme monokai-pro")
  end,
}
