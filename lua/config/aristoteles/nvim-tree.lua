return {
	disable_netrw = true,
	hijack_netrw = true,
	update_focused_file = {
		enable = true,
		update_root = false,
	},
	view = {
		width = 30,
		side = "right",
		preserve_window_proportions = true,
	},
	sync_root_with_cwd = true,
	actions = {
		open_file = {
			quit_on_open = false, -- Não feche o `nvim-tree` automaticamente ao abrir um arquivo.
		},
	},
	hijack_directories = {
		enable = false, -- Não deixe o `nvim-tree` dominar ao fechar buffers.
	},
}
