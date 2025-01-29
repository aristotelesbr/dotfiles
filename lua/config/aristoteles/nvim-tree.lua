return {
  sort_by = "case_sensitive",
	disable_netrw = true,
	hijack_netrw = true,
	filters = {
		git_ignored = false,
		dotfiles = false,
		custom = {},
		exclude = {},
	},
	update_focused_file = {
		enable = true,
		update_root = false,
	},
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
	},
	git = {
		enable = true,
		ignore = false,
		timeout = 400,
	},
	-- sync_root_with_cwd = true,
	-- actions = {
	-- 	open_file = {
	-- 		quit_on_open = false,
	-- 	},
	-- },
	-- hijack_directories = {
	-- 	enable = false,
	-- },
}
