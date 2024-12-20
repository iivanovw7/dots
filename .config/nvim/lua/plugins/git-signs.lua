return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      auto_attach = true,
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      signcolumn = true,
      signs_staged_enable = true,
    },
  },
}
