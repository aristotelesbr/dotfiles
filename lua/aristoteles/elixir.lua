local status_ok, elixirls = pcall(require, "elixir")

elixirls.setup({
	credo = {}, -- suporte ao linting com Credo
	elixirls = {
		enabled = true,
		settings = {
			dialyzerEnabled = false,
			fetchDeps = false,
		},
	},
})
