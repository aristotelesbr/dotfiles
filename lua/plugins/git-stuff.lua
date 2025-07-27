return {
  {
    "tpope/vim-fugitive",
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text_pos = "eol",
        delay = 300,
      },
      current_line_blame_formatter = "<author> • <author_time:%d-%m-%Y> • <summary>",
    },
    config = function(_, opts)
      local gs = require("gitsigns")
      gs.setup(opts)

      vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Pré-visualizar hunk" })
      vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Resetar hunk" })
      vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { desc = "Aplicar hunk" })
      vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Alternar blame da linha" })
    end,
  },
}
