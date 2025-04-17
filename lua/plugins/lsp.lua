local util = require("lspconfig.util")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {},
        ruby_lsp = {},
        rubocop = {},
        standardrb = {},
      },
      setup = {
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,

        -- Ruby IDE features
        ruby_lsp = function(_, opts)
          require("lspconfig").ruby_lsp.setup(opts)
          return true
        end,

        -- Rubocop LSP just exists if there is a .rubocop.yml file in the project root
        rubocop = function(_, opts)
          if util.root_pattern(".rubocop.yml", "rubocop.yml")(vim.fn.getcwd()) then
            require("lspconfig").rubocop.setup(opts)
          end
          return true
        end,

        -- Standardrb just exists if there is a .standard.yml file in the project root
        standardrb = function(_, opts)
          if util.root_pattern(".standard.yml", "standard.yml")(vim.fn.getcwd()) then
            require("lspconfig").standardrb.setup(opts)
          end
          return true
        end,
      },
    },
  },
}
