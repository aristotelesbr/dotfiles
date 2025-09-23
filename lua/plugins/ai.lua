return {
  {
    "github/copilot.vim",
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = false,
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      debug = false,
      show_help = true,
      mappings = {
        complete = { insert = "<C-Tab>" },
        close = { normal = "q", insert = "<C-c>" },
        reset = { normal = "<C-r>", insert = "<C-r>" },
        submit_prompt = { normal = "<CR>", insert = "<C-s>" },
      },
    },
    keys = {
      { "<leader>acd", "<cmd>CopilotChatDocs<cr>", desc = "copilot: generate documentation", mode = "v" },
      { "<leader>acr", "<cmd>CopilotChatReview<cr>", desc = "copilot: review code", mode = "v" },
      { "<leader>aco", "<cmd>CopilotChatCommit<cr>", desc = "copilot: commit changes", mode = "v" },
      { "<leader>acm", "<cmd>CopilotChatModel<cr>", desc = "copilot: select model", mode = "n" },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "stevearc/dressing.nvim", opts = {} },
    },
    config = function() end,
  },
  {
    "yetone/avante.nvim",
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- Optional dependencies
      "nvim-mini/mini.pick",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",
      "stevearc/dressing.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      provider = "deepseek",
      providers = {
        copilot = {
          endpoint = "https://api.github.com/copilot",
          api_key_name = "GITHUB_TOKEN",
          model = "github-copilot",
          models = {
            "github-copilot",
            "github-copilot-chat",
          },
        },
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-coder",
          max_tokens = 8192,
          disable_tools = true,
        },
      },
      alias = {
        ask = "avante: create new ask",
        buffers = "avante: add all open buffers",
        focus = "avante: focus",
        history = "avante: select history",
        repo = "avante: display repo map",
        suggestion = "avante: toggle suggestion",
        stop = "avante: stop",
        model = "avante: select model",
      },
    },
    config = function(_, opts)
      require("avante").setup(opts)
    end,
  },
}
