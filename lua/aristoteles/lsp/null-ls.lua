local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

local conditional = function(fn)
	local utils = require("null-ls.utils").make_conditional_utils()
	return fn(utils)
end

null_ls.setup({
	debug = false,
	sources = {
		formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
		diagnostics.eslint_d.with({
			condition = function(utils)
				return utils.root_has_file({ ".eslintrc.js" })
			end,
		}),
		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua,
		-- diagnostics.flake8,
		-- Here we set a conditional to call the rubocop formatter.
		-- If we have a Gemfile in the project, we call "bundle exec rubocop", if not we only call "rubocop".
		conditional(function(utils)
		  return utils.root_has_file("Gemfile")
		    and null_ls.builtins.formatting.rubocop.with({
		    command = "bundle",
		    args = vim.list_extend(
		      { "exec", "rubocop" },
		      null_ls.builtins.formatting.rubocop._opts.args
		    ),
		  })
		  or null_ls.builtins.formatting.rubocop
		end),

		-- Same as above, but with diagnostics.rubocop to make sure we use the
		-- proper rubocop version for the project
		conditional(function(utils)
		  return utils.root_has_file("Gemfile")
		    and null_ls.builtins.diagnostics.rubocop.with({
		    command = "bundle",
		    args = vim.list_extend(
		      { "exec", "rubocop" },
		      null_ls.builtins.diagnostics.rubocop._opts.args
		    ),
		  })
		  or null_ls.builtins.diagnostics.rubocop
		end),
	},
})
