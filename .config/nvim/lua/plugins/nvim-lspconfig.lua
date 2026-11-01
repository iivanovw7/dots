return {
  {
    "mason-org/mason.nvim",
    opts_extend = {
      "ensure_installed",
    },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "typescript-language-server",
        "css-lsp",
        "stylelint-language-server",
        "flake8",
        "shfmt",
        "codelldb",
        "biome",
      })
      if diagnostics == "bacon-ls" then
        vim.list_extend(opts.ensure_installed, { "bacon" })
      end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "bashls",
        "cssls",
        "cssmodules_ls",
        "tailwindcss",
        "eslint",
        "ts_ls",
        "html",
        "gradle_ls",
        "lua_ls",
        "jdtls",
        "jsonls",
        "lemminx",
        "marksman",
        "quick_lint_js",
        "yamlls",
        -- "rust_analyzer",
        "stylelint_lsp",
        "ltex",
      },
      handlers = {},
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim" },
      { "mason-org/mason-lspconfig.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { "j-hui/fidget.nvim", opts = {} },
      { "folke/neodev.nvim", opts = {} },
    },
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        bacon_ls = {
          enabled = diagnostics == "bacon_ls",
        },
        -- rust_analyzer = {
        --   enabled = true,
        --   procMacro = {
        --     enable = false,
        --   },
        --   inlayHints = {
        --     enable = false,
        --   },
        -- },
        eslint = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = true
          end,
        },
        ts_ls = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end,
        },
        stylelint_lsp = {
          filetypes = { "css", "scss", "less", "sass", "postcss" },
          cmd_env = {
            NODE_PATH = (vim.fs.root(0, "package.json") or vim.fn.getcwd()) .. "/node_modules",
          },
          settings = {
            stylelint = {
              validate = { "css", "scss", "less", "postcss" },
              lintInBundledCode = false,
            },
          },
          on_new_config = function(config)
            config.settings.stylelint = config.settings.stylelint or {}
            config.settings.stylelint.workingDirectory = { mode = "location" }
          end,
        },
        cssls = {
          settings = {
            css = { lint = { unknownAtRules = "ignore" } },
            scss = { lint = { unknownAtRules = "ignore", operatorNoUnspaced = "ignore" } },
            less = { lint = { unknownAtRules = "ignore" } },
          },
        },
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        html = {
          lintCommand = "djlint -q --format=json ${INPUT}",
          lintStdin = true,
          lintFormats = { "%f:%l:%c: %m" },
        },
        htmldjango = {
          lintCommand = "djlint -q --format=json ${INPUT}",
          lintStdin = true,
          lintFormats = { "%f:%l:%c: %m" },
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        typos_lsp = {
          cmd_env = { RUST_LOG = "error" },
          init_options = {
            diagnosticSeverity = "Information",
          },
        },
        ltex = {
          settings = {
            ltex = {
              enabled = { "latex", "tex", "bib", "markdown", "text", "gitcommit" },
              language = "en-US",
              diagnosticSeverity = "info",
              checkFrequency = "save",
              sentenceCacheSize = 2000,
              additionalRules = {
                enablePickyRules = false,
              },
              trace = {
                server = "verbose",
              },
              disabledRules = {
                ["en-GB"] = { "MORFOLOGIK_RULE_EN_GB" },
              },
            },
          },
        },
        lua_ls = {
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              type = {
                castNumberToInteger = true,
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
      },
    },
  },
}
