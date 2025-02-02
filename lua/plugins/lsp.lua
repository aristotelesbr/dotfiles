return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded" },
      })

      local function lsp_keymaps(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        local keymap = vim.keymap.set

        keymap("n", "gd", vim.lsp.buf.definition, opts)
        keymap("n", "gr", vim.lsp.buf.references, opts)
        keymap("n", "K", vim.lsp.buf.hover, opts)
        keymap("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, opts)
        keymap("n", "<leader>la", vim.lsp.buf.code_action, opts)
        keymap("n", "<leader>lr", vim.lsp.buf.rename, opts)
      end

      local lspconfig = require("lspconfig")

      local servers = {
        -- Web
        html = {
          filetypes = { "html", "eruby" }, -- Adiciona suporte para arquivos ERB
        },
        cssls = {},
        eslint = {},
        jsonls = {},
        tailwindcss = {
          filetypes = { "html", "eruby", "ruby" }, -- Adiciona suporte para ERB no Tailwind
        },

        -- Ruby
        ruby_lsp = {
          filetypes = { "ruby", "eruby" }, -- Adiciona suporte explícito para ERB
        },

        -- Outros
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
            },
          },
        },
        pyright = {},
        gopls = {},
        rust_analyzer = {},
      }

      require("mason").setup({
        ui = { border = "none" },
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      })

      vim.filetype.add({
        extension = {
          erb = "eruby",
          html = "html",
        },
      })

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = lsp_keymaps,
            settings = servers[server_name] and servers[server_name].settings or {},
            filetypes = servers[server_name] and servers[server_name].filetypes,
          })
        end,
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        eruby = { "erb_lint" }, -- Mudado de 'erb' para 'eruby'
        ruby = { "standardrb" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          eruby = { "erb_lint" }, -- Mudado de 'erb' para 'eruby'
          ruby = { "standardrb" },
        },
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = { border = "none" },
    },
    priority = 1000,
  },
}
