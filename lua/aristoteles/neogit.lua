local status_ok, neogit = pcall(require, "neogit")
if not status_ok then
	return
end

neogit.setup({
	kind = "status",
	integrations = { diffview = true },
})

local opts = { noremap = true, silent = true }
local mappings = {
	{
		"n",
		"<leader>gc",
		function()
			neogit.open({ "commit" })
		end,
		opts,
	},
	{
		"n",
		"<leader>gp",
		function()
			neogit.open({ "push" })
		end,
		opts,
	},
	{ "n", "<leader>gs", neogit.open, opts },
}
