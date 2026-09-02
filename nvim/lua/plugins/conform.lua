return {
  {
    "stevearc/conform.nvim",
    lazy = true,
    opts = {
      formatters_by_ft = {
        eruby = { "erb_format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        astro = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        go = { "goimports" },
      },
    },
  },
}
