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
}
