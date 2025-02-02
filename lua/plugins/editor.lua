return {
  { "nvim-lua/plenary.nvim", lazy = false },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup(require("config.aristoteles.autoparis"))

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done({
          map_char = { tex = "" },
        })
      )
    end,
  },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    event = "VeryLazy",
    config = true,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    config = true,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    priority = 999,
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = function()
      return require("config.aristoteles.whichkey").opts
    end,
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      require("config.aristoteles.whichkey").setup()
    end,
  },
  {
    "famiu/bufdelete.nvim",
    event = "VeryLazy",
  },
  {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local dashboard = require("config.aristoteles.alpha")
      require("alpha").setup(dashboard.opts)
      vim.keymap.set("n", "<leader>A", ":Alpha<CR>", { desc = "Dashboard", silent = true })
    end,
  },
}
