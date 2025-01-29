return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"RRethy/vim-illuminate",
		},
		config = function()
			local signs = {
				{ name = "DiagnosticSignError", text = "" },
				{ name = "DiagnosticSignWarn", text = "" },
				{ name = "DiagnosticSignHint", text = "" },
				{ name = "DiagnosticSignInfo", text = "" },
			}
			for _, sign in ipairs(signs) do
				vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
			end

			vim.diagnostic.config({
				virtual_text = false,
				signs = { active = signs },
				update_in_insert = true,
				underline = true,
				severity_sort = true,
				float = {
					focusable = true,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			})

			local function lsp_keymaps(_, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "<leader>lf", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
				vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", opts)
				vim.keymap.set("n", "<leader>lI", "<cmd>Mason<cr>", opts)
				vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, opts)
				vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, opts)
			end

			require("mason").setup({
				ui = {
					border = "none",
					icons = {
						package_installed = "◍",
						package_pending = "◍",
						package_uninstalled = "◍",
					},
				},
				max_concurrent_installers = 4,
			})

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
				pyright = {},
				html = {},
				jsonls = {},
				gopls = {},
				standardrb = {},
			}

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
				automatic_installation = true,
			})

			local lspconfig = require("lspconfig")
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					local opts = {
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							lsp_keymaps(client, bufnr)
							require("illuminate").on_attach(client)

							if client.name == "tsserver" or client.name == "lua_ls" then
								client.server_capabilities.documentFormattingProvider = false
							end
						end,
					}

					local server_opts = servers[server_name] or {}
					opts = vim.tbl_deep_extend("force", server_opts, opts)

					lspconfig[server_name].setup(opts)
				end,
			})
		end,
	},

	-- Formatação e Linting
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		opts = function()
			local null_ls = require("null-ls")
			local conditional = function(fn)
				local utils = require("null-ls.utils").make_conditional_utils()
				return fn(utils)
			end

			return {
				sources = {
					-- Ruby/Rails
					conditional(function(utils)
						return utils.root_has_file("Gemfile")
								and null_ls.builtins.formatting.erb_format.with({
									command = "bundle",
									args = { "exec", "erb-format", "--stdin" },
								})
							or null_ls.builtins.formatting.erb_format
					end),
					conditional(function(utils)
						return utils.root_has_file("Gemfile")
								and null_ls.builtins.diagnostics.erb_lint.with({
									command = "bundle",
									args = { "exec", "erb-lint", "--stdin" },
								})
							or null_ls.builtins.diagnostics.erb_lint
					end),

					-- JavaScript/TypeScript
					null_ls.builtins.formatting.prettier.with({
						extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
					}),
					null_ls.builtins.diagnostics.eslint_d.with({
						condition = function(utils)
							return utils.root_has_file({ ".eslintrc.js" })
						end,
					}),

					-- Python
					null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),

					-- Lua
					null_ls.builtins.formatting.stylua,

					-- Ruby
					-- conditional(function(utils)
					-- 	return utils.root_has_file("Gemfile")
					-- 			and null_ls.builtins.formatting.rubocop.with({
					-- 				command = "bundle",
					-- 				args = vim.list_extend(
					-- 					{ "exec", "rubocop" },
					-- 					null_ls.builtins.formatting.rubocop._opts.args
					-- 				),
					-- 			})
					-- 		or null_ls.builtins.formatting.rubocop
					-- end),
					-- conditional(function(utils)
					-- 	return utils.root_has_file("Gemfile")
					-- 			and null_ls.builtins.diagnostics.rubocop.with({
					-- 				command = "bundle",
					-- 				args = vim.list_extend(
					-- 					{ "exec", "rubocop" },
					-- 					null_ls.builtins.diagnostics.rubocop._opts.args
					-- 				),
					-- 			})
					-- 		or null_ls.builtins.diagnostics.rubocop
					-- end),
				},
			}
		end,
	},
}
