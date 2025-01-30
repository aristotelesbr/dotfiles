local M = {}

M.opts = {
	plugins = {
		marks = true,
		registers = true,
		spelling = {
			enabled = true,
			suggestions = 20,
		},
		presets = {
			operators = true,
			motions = true,
			text_objects = true,
			windows = true,
			nav = true,
			z = true,
			g = true,
		},
	},
	triggers = {
		{ "<leader>", mode = { "n", "v" } },
		{ "g", mode = { "n", "v" } },
		{ "z", mode = { "n", "v" } },
		{ "d", mode = { "n", "v" } },
		{ "y", mode = { "n", "v" } },
		{ "]", mode = { "n", "v" } },
		{ "[", mode = { "n", "v" } },
	},
	-- triggers_nowait = {
	-- 	"z=",
	-- 	"z.",
	-- 	"zf",
	-- 	"zg",
	-- 	"zw",
	-- },
	show_help = true,
	show_keys = true,
	-- key_labels = {
	-- 	["<leader>"] = "SPC",
	-- 	["<cr>"] = "↵",
	-- 	["<tab>"] = "⇆",
	-- },
}

M.setup = function()
	local wk = require("which-key")
	wk.setup(M.opts)

	wk.add({
		-- Main groups
		{ "<leader>f", desc = "+Find" },
		{ "<leader>g", desc = "+Git" },
		{ "<leader>l", desc = "+LSP" },
		{ "<leader>p", desc = "+Package" },
		{ "<leader>s", desc = "+Search" },
		{ "<leader>t", desc = "+Terminal" },
		{ "<leader>x", desc = "+Spell" },

		-- Direct mappings
		{ "<leader>F", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find Text" },
		{ "<leader>P", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects" },
		{ "<leader>A", "<cmd>Alpha<cr>", desc = "Dashboard" },
		{ "<leader>c", "<cmd>bd!<CR>:bnext<CR>", desc = "Close Buffer" },
		{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
		{ "<leader>h", "<cmd>nohlsearch<CR>", desc = "No Highlight" },
		{ "<leader>q", "<cmd>q!<CR>", desc = "Quit" },
		{ "<leader>w", "<cmd>w!<CR>", desc = "Save" },
		{
			"<leader>b",
			"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
			desc = "Buffers",
		},

		-- Find Group
		{
			"<leader>ff",
			"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
			desc = "Find Files",
		},
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },

		-- Git Group
		{ "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
		{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout Branch" },
		{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout Commit" },
		{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff" },
		{ "<leader>gg", "<cmd>LazyGit<CR>", desc = "Lazygit" },
		{ "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk" },
		{ "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk" },
		{ "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame" },
		{ "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open Changed File" },
		{ "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
		{ "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
		{ "<leader>gs", "<cmd>Neogit<cr>", desc = "Status" },
		{ "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },

		-- LSP Group
		{ "<leader>lI", "<cmd>Mason<cr>", desc = "Mason Info" },
		{ "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
		{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
		{ "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
		{ "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>", desc = "Format" },
		{ "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
		{ "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },
		{ "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
		{ "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
		{ "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
		{ "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
		{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
		{ "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },

		-- Package Group
		{ "<leader>pS", "<cmd>Lazy show<cr>", desc = "Status" },
		{ "<leader>pc", "<cmd>Lazy check<cr>", desc = "Check" },
		{ "<leader>pi", "<cmd>Lazy install<cr>", desc = "Install" },
		{ "<leader>ps", "<cmd>Lazy sync<cr>", desc = "Sync" },
		{ "<leader>pu", "<cmd>Lazy update<cr>", desc = "Update" },

		-- Search Group
		{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
		{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
		{ "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
		{ "<leader>sb", "<cmd>Telescope git_branches<cr>", desc = "Checkout Branch" },
		{ "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
		{ "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },

		-- Terminal Group
		{ "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float" },
		{ "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal" },
		{ "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", desc = "Node" },
		{ "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", desc = "Python" },
		{ "<leader>tt", "<cmd>lua _HTOP_TOGGLE()<cr>", desc = "Htop" },
		{ "<leader>tu", "<cmd>lua _NCDU_TOGGLE()<cr>", desc = "NCDU" },
		{ "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical" },

		-- Spell Group
		{ "<leader>xe", "<cmd>set spell! spelllang=en_us<CR>", desc = "Toggle English" },
		{ "<leader>xt", "<cmd>set spell! spelllang=pt_br<CR>", desc = "Toggle Português" },
	})
end

return M
