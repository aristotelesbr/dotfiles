return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = true,
	},
	{
		"TimUntersberger/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"sindrets/diffview.nvim",
			"ibhagwan/fzf-lua",
		},
		cmd = "Neogit",
		config = true,
	},

	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
		},
		config = function()
			require("config.aristoteles.telescope")
		end,
	},

	-- DevContainers e ferramentas especializadas
	{
		"esensar/nvim-dev-container",
		lazy = false,
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("devcontainer").setup({
				container_runtime = "docker",
				attach_mounts = {
					always = true,
					neovim_config = {
						enabled = true,
						options = { "readonly" },
					},
					neovim_data = {
						enabled = false,
						options = {},
					},
					nvim_state = {
						enabled = false,
						options = {},
					},
				},
			})
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = { "InsertEnter" },
		config = function()
			require("copilot").setup(require("config.aristoteles.copilot"))
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		lazy = false,
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"michaelb/sniprun",
		build = "bash ./install.sh",
		cmd = { "SnipRun", "SnipInfo" },
	},
	{
		"elixir-tools/elixir-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		ft = "elixir",
		config = true,
	},
}
