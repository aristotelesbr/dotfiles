return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim",
  },
  opts = function(_, opts)
    opts.filesystem = opts.filesystem or {}
    opts.filesystem.commands = opts.filesystem.commands or {}
    opts.filesystem.window = opts.filesystem.window or {}

    opts.filesystem.commands.copy_relpath_to_clipboard = function(state)
      local node = state.tree:get_node()
      local cwd = vim.loop.cwd()
      local relpath = node.path:gsub("^" .. cwd .. "/", "")
      vim.fn.setreg("+", relpath)
    end

    opts.filesystem.window.mappings = vim.tbl_extend("force", opts.filesystem.window.mappings or {}, {
      y = "copy_relpath_to_clipboard",
    })
  end,
}
