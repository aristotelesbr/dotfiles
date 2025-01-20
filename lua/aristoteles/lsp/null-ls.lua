local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local conditional = function(fn)
	local utils = require("null-ls.utils").make_conditional_utils()
	return fn(utils)
end

null_ls.setup({
	debug = false,
	sources = {
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
		formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
		diagnostics.eslint_d.with({
			condition = function(utils)
				return utils.root_has_file({ ".eslintrc.js" })
			end,
		}),

		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua,

		conditional(function(utils)
			return utils.root_has_file("Gemfile")
					and null_ls.builtins.formatting.rubocop.with({
						command = "bundle",
						args = vim.list_extend({ "exec", "rubocop" }, null_ls.builtins.formatting.rubocop._opts.args),
					})
				or null_ls.builtins.formatting.rubocop
		end),

		-- Same as above, but with diagnostics.rubocop to make sure we use the
		-- proper rubocop version for the project
		conditional(function(utils)
			return utils.root_has_file("Gemfile")
					and null_ls.builtins.diagnostics.rubocop.with({
						command = "bundle",
						args = vim.list_extend({ "exec", "rubocop" }, null_ls.builtins.diagnostics.rubocop._opts.args),
					})
				or null_ls.builtins.diagnostics.rubocop
		end),

		--------------------------------------------------

		-- StandardRB
		-- conditional(function(utils)
		-- 	return utils.root_has_file("Gemfile")
		-- 			and null_ls.builtins.formatting.standardrb.with({
		-- 				command = "bundle",
		-- 				args = vim.list_extend(
		-- 					{ "exec", "standardrb" },
		-- 					null_ls.builtins.formatting.standardrb._opts.args
		-- 				),
		-- 			})
		-- 		or null_ls.builtins.formatting.standardrb
		-- end),

		-- Same as above, but with diagnostics.standardrb to make sure we use the StandardRB
		-- conditional(function(utils)
		-- 	return utils.root_has_file("Gemfile")
		-- 			and null_ls.builtins.diagnostics.standardrb.with({
		-- 				command = "bundle",
		-- 				args = vim.list_extend(
		-- 					{ "exec", "standardrb" },
		-- 					null_ls.builtins.diagnostics.standardrb._opts.args
		-- 				),
		-- 			})
		-- 		or null_ls.builtins.diagnostics.standardrb
		-- end),
		--------------------------------------------------
	},
})
