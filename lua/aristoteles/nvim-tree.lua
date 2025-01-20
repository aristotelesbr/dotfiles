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
})