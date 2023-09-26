return {
  {
    "Mofiqul/dracula.nvim",
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      colors = {
        bg = "#282A36",
        fg = "#F8F8F2",
        selection = "#44475A",
        comment = "#6272A4",
        red = "#FF5555",
        orange = "#FFB86C",
        yellow = "#F1FA8C",
        green = "#50fa7b",
        purple = "#BD93F9",
        cyan = "#8BE9FD",
        pink = "#FF79C6",
        bright_red = "#FF6E6E",
        bright_green = "#69FF94",
        bright_yellow = "#FFFFA5",
        bright_blue = "#D6ACFF",
        bright_magenta = "#FF92DF",
        bright_cyan = "#A4FFFF",
        bright_white = "#FFFFFF",
        menu = "#21222C",
        visual = "#3E4452",
        gutter_fg = "#4B5263",
        nontext = "#3B4048",
        white = "#ABB2BF",
        black = "#191A21",
      },
      -- show the '~' characters after the end of buffers
      show_end_of_buffer = true, -- default false
      -- use transparent background
      transparent_bg = true, -- default false
      -- set custom lualine background color
      lualine_bg_color = "#44475a", -- default nil
      -- set italic comment
      italic_comment = true, -- default false
      -- overrides the default highlights with table see `:h synIDattr`
      overrides = {},
      -- You can use overrides as table like this
      -- overrides = {
      --   NonText = { fg = "white" }, -- set NonText fg to white
      --   NvimTreeIndentMarker = { link = "NonText" }, -- link to NonText highlight
      --   Nothing = {} -- clear highlight of Nothing
      -- },
      -- Or you can also use it like a function to get color from theme
      -- overrides = function (colors)
      --   return {
      --     NonText = { fg = colors.white }, -- set NonText fg to white of theme
      --   }
      -- end,
    },
  },
    --[[
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = {
            term_colors = true,
            transparent_background = false,
            styles = {
                comments = {},
                conditionals = {},
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
            },
            color_overrides = {
                mocha = {
                    rosewater = "#ffc9c9",
                    flamingo = "#ff9f9a",
                    pink = "#ffa9c9",
                    mauve = "#df95cf",
                    lavender = "#a990c9",
                    red = "#ff6960",
                    maroon = "#f98080",
                    peach = "#f9905f",
                    yellow = "#f9bd69",
                    green = "#b0d080",
                    teal = "#a0dfa0",
                    sky = "#a0d0c0",
                    sapphire = "#95b9d0",
                    blue = "#89a0e0",
                    text = "#e0d0b0",
                    subtext1 = "#d5c4a1",
                    subtext0 = "#bdae93",
                    overlay2 = "#928374",
                    overlay1 = "#7c6f64",
                    overlay0 = "#665c54",
                    surface2 = "#504844",
                    surface1 = "#3a3634",
                    surface0 = "#252525",
                    base = "#151515",
                    mantle = "#0e0e0e",
                    crust = "#080808",
                },
            },
        },
    },
    ]]--
}
