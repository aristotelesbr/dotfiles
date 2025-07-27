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
      { "<leader>acc", "<cmd>CopilotChat<cr>", desc = "copilot: open chat", mode = { "n", "v" } },
      { "<leader>ace", "<cmd>CopilotChatExplain<cr>", desc = "copilot: explain code", mode = "v" },
      { "<leader>acf", "<cmd>CopilotChatFix<cr>", desc = "copilot: fix code", mode = "v" },
      { "<leader>acd", "<cmd>CopilotChatDocs<cr>", desc = "copilot: generate documentation", mode = "v" },
      { "<leader>act", "<cmd>CopilotChatTests<cr>", desc = "copilot: generate tests", mode = "v" },
      { "<leader>acr", "<cmd>CopilotChatReview<cr>", desc = "copilot: review code", mode = "v" },
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
      { "nvim-treesitter/nvim-treesitter" },
      { "stevearc/dressing.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "MunifTanjim/nui.nvim" },
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
          disable_tools = true,
        },
        deepseek_r1 = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-r1",
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
