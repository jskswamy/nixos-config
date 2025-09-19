return {
	-- Add Nix language support
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Nix language server
				nil_ls = {
					settings = {
						["nil"] = {
							formatting = {
								command = { "nixpkgs-fmt" },
							},
						},
					},
				},

				-- Additional language servers
				bashls = {}, -- Bash/shell scripting
				dockerls = {}, -- Docker
				html = {}, -- HTML
				cssls = {}, -- CSS
			},
		},
	},

	-- Enhanced treesitter support
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"css",
				"dockerfile",
				"go",
				"gomod",
				"gosum",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"nix",
				"python",
				"terraform",
				"typescript",
				"tsx",
				"vim",
				"yaml",
			},
		},
	},

	-- Mason tool installer for language servers and formatters
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				-- Language servers
				"typescript-language-server",
				"pyright",
				"gopls",
				"terraform-ls",
				"nil", -- Nix language server
				"bash-language-server",
				"yaml-language-server",
				"dockerfile-language-server",
				"html-lsp",
				"css-lsp",
				"marksman", -- Markdown LSP
				"json-lsp",

				-- Best formatters for each language
				"biome", -- Modern JS/TS/JSON formatter (faster than prettier)
				"ruff", -- Python formatter + linter (replaces black, isort, flake8)
				"gofumpt", -- Go formatter (stricter than gofmt)
				"goimports", -- Go imports organizer
				"nixpkgs-fmt", -- Nix formatter
				"shfmt", -- Shell script formatter
				"stylua", -- Lua formatter
				"prettier", -- Fallback for YAML/Markdown

				-- Best linters for each language
				"eslint_d", -- JS/TS linter (fast daemon version)
				"golangci-lint", -- Go meta-linter (includes many linters)
				"tflint", -- Terraform linter
				"shellcheck", -- Shell script linter
				"markdownlint-cli2", -- Modern Markdown linter
				"yamllint", -- YAML linter
				"stylelint", -- CSS linter
				"htmlhint", -- HTML linter
			},
		},
	},

	-- Configure auto-formatting on save with best tools
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				-- JavaScript/TypeScript - use Biome (faster, modern alternative to Prettier)
				javascript = { "biome" },
				typescript = { "biome" },
				javascriptreact = { "biome" },
				typescriptreact = { "biome" },
				json = { "biome" },

				-- Python - use Ruff (does both formatting and import sorting)
				python = { "ruff_format", "ruff_organize_imports" },

				-- Go - use goimports + gofumpt for best formatting
				go = { "goimports", "gofumpt" },

				-- Web technologies
				html = { "prettier" },
				css = { "prettier" },

				-- Documentation - use prettier for consistency
				markdown = { "prettier" },
				yaml = { "prettier" },

				-- System languages
				nix = { "nixpkgs_fmt" },
				terraform = { "terraform_fmt" },
				sh = { "shfmt" },
				bash = { "shfmt" },

				-- Lua
				lua = { "stylua" },
			},
		},
	},

	-- Configure linting with nvim-lint
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				python = { "ruff" },
				go = { "golangci_lint" },
				terraform = { "tflint" },
				sh = { "shellcheck" },
				bash = { "shellcheck" },
				markdown = { "markdownlint-cli2" },
				yaml = { "yamllint" },
				css = { "stylelint" },
				html = { "htmlhint" },
			},
		},
	},

	-- Nix-specific enhancements
	{
		"LnL7/vim-nix",
		ft = "nix",
	},

	-- Biome configuration for modern JS/TS formatting
	{
		"stevearc/conform.nvim",
		opts = {
			formatters = {
				biome = {
					condition = function(ctx)
						return vim.fs.find({ "biome.json", "biome.jsonc" }, { path = ctx.filename, upward = true })[1]
					end,
				},
			},
		},
	},
}

