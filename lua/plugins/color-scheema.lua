return {
  {
    "Tsuzat/NeoSolarized.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[ colorscheme NeoSolarized ]])
    end,
  },
}
