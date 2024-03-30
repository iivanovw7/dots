return {
  "loctvl842/monokai-pro.nvim",
  config = function()
    require("monokai-pro").setup({
      transparent_background = false,
      terminal_colors = true,
      filter = "spectrum",
      devicons = true,
      inc_search = "background",
    })
  end,
}
