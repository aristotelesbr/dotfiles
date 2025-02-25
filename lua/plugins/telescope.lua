-- change some telescope options and a keymap to browse plugin files
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<C-p>",
      function()
        require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
      end,
      desc = "Find Plugin File",
    },
    -- stylua: ignore
    {
      "<leader>F",
      function()
        require("telescope.builtin").live_grep({ cwd = vim.loop.cwd() })
      end,
      desc = "Live grep in current project",
    },
  },
  -- change some options
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
    },
  },
}
