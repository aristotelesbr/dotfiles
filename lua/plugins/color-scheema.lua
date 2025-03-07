return {
  {
    "DAddYE/soda.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme soda]])
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  },
}
