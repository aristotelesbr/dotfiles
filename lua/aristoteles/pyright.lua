local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

lspconfig.pyright.setup({
	root_dir = util.root_pattern(".venv", "pyproject.toml", "setup.py", "requirements.txt", ".git"),
	settings = {
		python = {
			pythonPath = vim.fn.getcwd() .. "/.venv/bin/python",
		},
	},
})
