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
				"stylelint-lsp",
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
				"rust_analyzer",
				"stylelint_lsp",
			},
			handlers = {
				stylelint_lsp = {
					cmd = { "stylelint-lsp", "--stdio" },
					filetypes = { "css", "scss", "less", "sass", "postcss" },
					settings = {
						stylelintplus = {
							autoFixOnSave = true,
							autoFixOnFormat = true,
							runOnType = true,
						},
					},
					on_attach = function(client, bufnr)
						vim.diagnostic.config({
							virtual_text = { prefix = "", spacing = 2 },
							signs = true,
							underline = true,
							update_in_insert = true,
						})

						if client.server_capabilities.documentFormattingProvider then
							vim.api.nvim_clear_autocmds({ group = "StylelintFormat", buffer = bufnr })
							vim.api.nvim_create_autocmd("BufWritePre", {
								group = vim.api.nvim_create_augroup("StylelintFormat", { clear = true }),
								buffer = bufnr,
								callback = function()
									vim.lsp.buf.format({
										async = false,
										filter = function(c)
											return c.name == "stylelint_lsp"
										end,
									})
								end,
							})
						end
					end,
					root_dir = function(fname)
						local util = require("lspconfig.util")

						local root = util.root_pattern(
							".stylelintrc",
							".stylelintrc.json",
							".stylelintrc.yaml",
							".stylelintrc.yml",
							".stylelintrc.js",
							".stylelintrc.cjs",
							".stylelintrc.mjs",
							"stylelint.config.js",
							"stylelint.config.cjs",
							"stylelint.config.mjs",
							"package.json"
						)(fname)

						if root then
							return root
						end

						local git_dir = vim.fs.find(".git", { path = fname, upward = true })[1]
						if git_dir then
							return vim.fs.dirname(git_dir)
						end

						return vim.fs.dirname(fname)
					end,
				},
			},
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
				rust_analyzer = {
					enabled = true,
				},
				eslint = {},
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
				html = {},
				yamlls = {
					settings = {
						yaml = {
							keyOrdering = false,
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
			setup = {
				stylelint_lsp = function(_, opts)
					opts.filetypes = { "css", "scss", "less", "sass", "postcss" }

					require("lazyvim.util").lsp.on_attach(function(client)
						if client.name == "stylelint_lsp" then
							client.server_capabilities.diagnosticProvider = {
								interFileDependencies = false,
								workspaceDiagnostics = false,
							}

							client.server_capabilities.documentFormattingProvider = true
						end
					end)
				end,
				eslint = function()
					require("lazyvim.util").lsp.on_attach(function(client)
						if client.name == "eslint" then
							client.server_capabilities.documentFormattingProvider = true
						elseif client.name == "tsserver" then
							client.server_capabilities.documentFormattingProvider = false
						end
					end)
				end,
			},
		},
	},
}
