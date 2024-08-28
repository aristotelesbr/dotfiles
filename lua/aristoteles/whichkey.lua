local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local opts = {
	theme = "ayu_light",
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	{
		"<leader>a",
		"<cmd>Alpha<cr>",
		desc = "Alpha",
	},
	{
		"<leader>b",
		"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
		desc = "Buffers",
	},
	{
		"<leader>e",
		"<cmd>NvimTreeToggle<cr>",
		desc = "Explorer",
	},
	{
		"<leader>w",
		"<cmd>w!<CR>",
		desc = "Save",
	},
	{
		"<leader>q",
		"<cmd>q!<CR>",
		desc = "Quit",
	},
	{
		"<leader>c",
		"<cmd>Bdelete!<CR>",
		desc = "Close Buffer",
	},
	{
		"<leader>h",
		"<cmd>nohlsearch<CR>",
		desc = "No Highlight",
	},
	{
		"<leader>f",
		"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
		desc = "Find files",
	},
	{
		"<leader>F",
		"<cmd>Telescope live_grep theme=ivy<cr>",
		desc = "Find Text",
	},
	{
		"<leader>P",
		"<cmd>lua require('telescope').extensions.projects.projects()<cr>",
		desc = "Projects",
	},

	-- Grupo de comandos para o Packer
	{ "<leader>p", group = "Packer" },
	{
		"<leader>pc",
		"<cmd>PackerCompile<cr>",
		desc = "Compile",
	},
	{
		"<leader>pi",
		"<cmd>PackerInstall<cr>",
		desc = "Install",
	},
	{
		"<leader>ps",
		"<cmd>PackerSync<cr>",
		desc = "Sync",
	},
	{
		"<leader>pS",
		"<cmd>PackerStatus<cr>",
		desc = "Status",
	},
	{
		"<leader>pu",
		"<cmd>PackerUpdate<cr>",
		desc = "Update",
	},

	-- Grupo de comandos para o Git
	{ "<leader>g", group = "Git" },
	{
		"<leader>gg",
		"<cmd>lua _LAZYGIT_TOGGLE()<CR>",
		desc = "Lazygit",
	},
	{
		"<leader>gj",
		"<cmd>lua require 'gitsigns'.next_hunk()<cr>",
		desc = "Next Hunk",
	},
	{
		"<leader>gk",
		"<cmd>lua require 'gitsigns'.prev_hunk()<cr>",
		desc = "Prev Hunk",
	},
	{
		"<leader>gl",
		"<cmd>lua require 'gitsigns'.blame_line()<cr>",
		desc = "Blame",
	},
	{
		"<leader>gp",
		"<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
		desc = "Preview Hunk",
	},
	{
		"<leader>gr",
		"<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
		desc = "Reset Hunk",
	},
	{
		"<leader>gR",
		"<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
		desc = "Reset Buffer",
	},
	{
		"<leader>gs",
		"<cmd>:Neogit<cr>",
		desc = "Open Neogit",
	},
	{
		"<leader>gu",
		"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
		desc = "Undo Stage Hunk",
	},
	{
		"<leader>go",
		"<cmd>Telescope git_status<cr>",
		desc = "Open changed file",
	},
	{
		"<leader>gb",
		"<cmd>Telescope git_branches<cr>",
		desc = "Checkout branch",
	},
	{
		"<leader>gc",
		"<cmd>Telescope git_commits<cr>",
		desc = "Checkout commit",
	},
	{
		"<leader>gd",
		"<cmd>Gitsigns diffthis HEAD<cr>",
		desc = "Diff",
	},

	-- Grupo de comandos para o LSP
	{ "<leader>l", group = "LSP" },
	{
		"<leader>la",
		"<cmd>lua vim.lsp.buf.code_action()<cr>",
		desc = "Code Action",
	},
	{
		"<leader>ld",
		"<cmd>Telescope diagnostics bufnr=0<cr>",
		desc = "Document Diagnostics",
	},
	{
		"<leader>lw",
		"<cmd>Telescope diagnostics<cr>",
		desc = "Workspace Diagnostics",
	},
	{
		"<leader>lf",
		"<cmd>lua vim.lsp.buf.format{async=true}<cr>",
		desc = "Format",
	},
	{
		"<leader>li",
		"<cmd>LspInfo<cr>",
		desc = "Info",
	},
	{
		"<leader>lI",
		"<cmd>LspInstallInfo<cr>",
		desc = "Installer Info",
	},
	{
		"<leader>lj",
		"<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
		desc = "Next Diagnostic",
	},
	{
		"<leader>lk",
		"<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
		desc = "Prev Diagnostic",
	},
	{
		"<leader>ll",
		"<cmd>lua vim.lsp.codelens.run()<cr>",
		desc = "CodeLens Action",
	},
	{
		"<leader>lq",
		"<cmd>lua vim.diagnostic.setloclist()<cr>",
		desc = "Quickfix",
	},
	{
		"<leader>lr",
		"<cmd>lua vim.lsp.buf.rename()<cr>",
		desc = "Rename",
	},
	{
		"<leader>ls",
		"<cmd>Telescope lsp_document_symbols<cr>",
		desc = "Document Symbols",
	},
	{
		"<leader>lS",
		"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
		desc = "Workspace Symbols",
	},

	-- Grupo de comandos para Pesquisa
	{ "<leader>s", group = "Search" },
	{
		"<leader>sb",
		"<cmd>Telescope git_branches<cr>",
		desc = "Checkout branch",
	},
	{
		"<leader>sc",
		"<cmd>Telescope colorscheme<cr>",
		desc = "Colorscheme",
	},
	{
		"<leader>sh",
		"<cmd>Telescope help_tags<cr>",
		desc = "Find Help",
	},
	{
		"<leader>sM",
		"<cmd>Telescope man_pages<cr>",
		desc = "Man Pages",
	},
	{
		"<leader>sr",
		"<cmd>Telescope oldfiles<cr>",
		desc = "Open Recent File",
	},
	{
		"<leader>sR",
		"<cmd>Telescope registers<cr>",
		desc = "Registers",
	},
	{
		"<leader>sk",
		"<cmd>Telescope keymaps<cr>",
		desc = "Keymaps",
	},
	{
		"<leader>sC",
		"<cmd>Telescope commands<cr>",
		desc = "Commands",
	},

	-- Grupo de comandos para o Terminal
	{ "<leader>T", group = "Terminal" },
	{
		"<leader>Tn",
		"<cmd>lua _NODE_TOGGLE()<cr>",
		desc = "Node",
	},
	{
		"<leader>Tu",
		"<cmd>lua _NCDU_TOGGLE()<cr>",
		desc = "NCDU",
	},
	{
		"<leader>Tt",
		"<cmd>lua _HTOP_TOGGLE()<cr>",
		desc = "Htop",
	},
	{
		"<leader>Tp",
		"<cmd>lua _PYTHON_TOGGLE()<cr>",
		desc = "Python",
	},
	{
		"<leader>Tf",
		"<cmd>ToggleTerm direction=float<cr>",
		desc = "Float",
	},
	{
		"<leader>Th",
		"<cmd>ToggleTerm size=10 direction=horizontal<cr>",
		desc = "Horizontal",
	},
	{
		"<leader>Tv",
		"<cmd>ToggleTerm size=80 direction=vertical<cr>",
		desc = "Vertical",
	},
}

which_key.add(mappings, opts)
