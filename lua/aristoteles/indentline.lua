local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

nvim_tree.setup({
	sort_by = "case_sensitive",
	view = {
		width = 30,
		side = "right",
	},
	renderer = {
		group_empty = true,
		highlight_git = true,
		indent_markers = {
			enable = true,
		},
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					arrow_open = "",
					arrow_closed = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					untracked = "U",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	filters = {
		dotfiles = true,
		custom = { "node_modules", ".git" },
	},
	git = {
		enable = true,
		ignore = false,
		timeout = 400,
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = true,
		update_root = true,
	},
	renderer = {
		indent_width = 2,
		indent_markers = {
			enable = true,
			inline_arrows = true,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				bottom = "─",
				none = " ",
			},
		},
		icons = {
			webdev_colors = true,
			show = {
				folder_arrow = false, -- Desabilita a seta da pasta para usar apenas os marcadores de indentação
			},
		},
		group_empty = false, -- Não agrupa diretórios vazios
		special_files = {}, -- Não destaca arquivos especiais
	},
})
