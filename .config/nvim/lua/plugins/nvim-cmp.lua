return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    requires = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-omni",
    },
    build = "make install_jsregexp",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      {
        "tzachar/cmp-tabnine",
        build = {
          LazyVim.is_win() and "pwsh -noni .\\install.ps1" or "./install.sh",
          ":CmpTabnineHub",
        },
        dependencies = "hrsh7th/nvim-cmp",
        opts = {
          max_lines = 1000,
          max_num_results = 8,
          sort = true,
        },
        config = function(_, opts)
          require("cmp_tabnine.config"):setup(opts)
        end,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      -- table.insert(opts.sources, {
      --   name = "cmp_tabnine",
      --   group_index = 1,
      --   priority = 100,
      -- })
      --
      -- table.insert(opts.sources, {
      --   name = "nvim_px_to_rem",
      --   group_index = 1,
      --   priority = 100,
      -- })

      opts.sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
        {
          name = "cmp_tabnine",
          group_index = 1,
          priority = 100,
        },
        {
          name = "nvim_px_to_rem",
          group_index = 1,
          priority = 100,
        },
      }, {
        { name = "buffer" },
      })

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        [";"] = nil,
        ["<Tab>"] = nil,
        ["<C-j>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-k>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
}
