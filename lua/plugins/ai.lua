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
    config = function()
      local codecompanion = require("codecompanion")
      codecompanion.setup({
        strategies = {
          chat = { adapter = "deepseek" },
          inline = { adapter = "deepseek" },
          agent = { adapter = "deepseek" },
        },
        adapters = {
          deepseek = function()
            return require("codecompanion.adapters").extend("deepseek", {
              env = { api_key = "DEEPSEEK_API_KEY" },
              model = "deepseek-coder",
            })
          end,
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = { api_key = "ANTHROPIC_API_KEY" },
              schema = { model = { default = "claude-3-5-sonnet-20241022" } },
            })
          end,
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              env = { api_key = "OPENAI_API_KEY" },
              schema = { model = { default = "gpt-4o" } },
            })
          end,
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              schema = { model = { default = "llama3.1:8b" } },
              opts = {
                system_prompt = "You are a programming assistant fluent in Brazilian Portuguese. Answer all questions and generate all content in Brazilian Portuguese unless I explicitly request another language.",
              },
            })
          end,
        },
        prompts = {
          ["Explain Code"] = {
            strategy = "chat",
            description = "Explains selected code in detail (Brazilian Portuguese)",
            opts = { modes = { "v" }, auto_submit = true },
            prompts = {
              {
                role = "system",
                content = "Explain the code in Brazilian Portuguese, detailing purpose, logic, and key concepts.",
              },
              { role = "user", content = "{{{input}}}" },
            },
          },
          ["Refactor Code"] = {
            strategy = "inline",
            description = "Refactors selected code for better readability and performance",
            opts = { modes = { "v" }, auto_submit = true },
            prompts = {
              {
                role = "system",
                content = "Refactor the code to improve readability, performance, or maintainability. Provide the refactored code and an explanation in Brazilian Portuguese.",
              },
              { role = "user", content = "{{{input}}}" },
            },
          },
          ["Generate Tests"] = {
            strategy = "chat",
            description = "Generates unit tests for selected code",
            opts = { modes = { "v" }, auto_submit = true },
            prompts = {
              {
                role = "system",
                content = "Generate unit tests for the provided code, using the appropriate language and framework. Explain the tests in Brazilian Portuguese.",
              },
              { role = "user", content = "{{{input}}}" },
            },
          },
        },
        display = {
          show_model = true,
        },
      })
      local keymap = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }
      keymap(
        "n",
        "<leader>acd",
        "<cmd>CodeCompanionChat deepseek<cr>",
        vim.tbl_extend("force", opts, { desc = "🤖 Chat: DeepSeek (DeepSeek)" })
      )
      keymap(
        "n",
        "<leader>ach",
        "<cmd>CodeCompanionChat anthropic<cr>",
        vim.tbl_extend("force", opts, { desc = "🤖 Chat: Claude (Anthropic)" })
      )
      keymap(
        "v",
        "<leader>ach",
        "<cmd>CodeCompanionChat anthropic<cr>",
        vim.tbl_extend("force", opts, { desc = "🤖 Chat: Claude (Anthropic)" })
      )
      keymap(
        "n",
        "<leader>aco",
        "<cmd>CodeCompanionChat ollama<cr>",
        vim.tbl_extend("force", opts, { desc = "🤖 Chat: Ollama (Local)" })
      )
      keymap(
        "v",
        "<leader>aco",
        "<cmd>CodeCompanionChat ollama<cr>",
        vim.tbl_extend("force", opts, { desc = "🤖 Chat: Ollama (Local)" })
      )
      keymap(
        "n",
        "<leader>acg",
        "<cmd>CodeCompanionChat openai<cr>",
        vim.tbl_extend("force", opts, { desc = "🤖 Chat: GPT-4o (OpenAI)" })
      )
      keymap(
        "v",
        "<leader>acg",
        "<cmd>CodeCompanionChat openai<cr>",
        vim.tbl_extend("force", opts, { desc = "🤖 Chat: GPT-4o (OpenAI)" })
      )
      keymap(
        "v",
        "<leader>aae",
        "<cmd>CodeCompanion /Explain Code<cr>",
        vim.tbl_extend("force", opts, { desc = "🤖 Explain selected code" })
      )
      keymap(
        "v",
        "<leader>aar",
        "<cmd>CodeCompanion /Refactor Code<cr>",
        vim.tbl_extend("force", opts, { desc = "🤖 Refactor selected code" })
      )
      keymap(
        "v",
        "<leader>aat",
        "<cmd>CodeCompanion /Generate Tests<cr>",
        vim.tbl_extend("force", opts, { desc = "🤖 Generate tests for code" })
      )
      keymap(
        "v",
        "<leader>aaa",
        "<cmd>CodeCompanionActions<cr>",
        vim.tbl_extend("force", opts, { desc = "🤖 AI actions menu" })
      )
      local models = {
        { name = "LLaMA 3.1 (8B)", value = "llama3.1:8b" },
        { name = "CodeLLaMA (7B)", value = "codellama:7b" },
        { name = "Mistral Small", value = "mistral-small:latest" },
        { name = "DeepSeek R1 (1.5B)", value = "deepseek-r1:1.5b" },
      }
      keymap("n", "<leader>ams", "", {
        noremap = true,
        silent = true,
        desc = "🤖 Select model (Ollama)",
        callback = function()
          vim.ui.select(models, {
            prompt = "Select model for CodeCompanion (Ollama):",
            format_item = function(item)
              return item.name
            end,
          }, function(choice)
            if choice then
              codecompanion.setup({
                strategies = {
                  chat = { adapter = "ollama", schema = { model = { default = choice.value } } },
                  inline = { adapter = "ollama", schema = { model = { default = choice.value } } },
                  agent = { adapter = "ollama", schema = { model = { default = choice.value } } },
                },
              })
              vim.notify("Model changed to: " .. choice.name, vim.log.levels.INFO)
            end
          end)
        end,
      })
      vim.api.nvim_create_user_command("CodeCompanionCurrentModel", function()
        local current_adapter = codecompanion.config.strategies.chat.adapter
        local current_model = codecompanion.config.adapters[current_adapter]().schema.model.default
        vim.notify("Current model: " .. current_model .. " (" .. current_adapter .. ")", vim.log.levels.INFO)
      end, { desc = "Show current CodeCompanion model" })
      keymap(
        "n",
        "<leader>amc",
        "<cmd>CodeCompanionCurrentModel<cr>",
        vim.tbl_extend("force", opts, { desc = "🤖 Show current model" })
      )
    end,
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
        openai = {
          endpoint = "https://api.openai.com/v1/chat/completions",
          api_key_name = "OPENAI_API_KEY",
          model = "gpt-4o",
        },
        anthropic = {
          __inherited_from = "openai",
          endpoint = "https://api.anthropic.com/v1/messages",
          api_key_name = "ANTHROPIC_API_KEY",
          model = "claude-3-5-sonnet-20241022",
        },
        ollama = {
          endpoint = "http://localhost:11434/api/chat",
          model = "llama3.1:8b",
          models = {
            "llama3.1:8b",
            "mistral-small:latest",
            "codellama:13b",
            "deepseek-r1:1.5b",
          },
        },
        deepseek = {
          __inherited_from = "openai",
          api_key_name = { "bw", "get", "notes", "deepseek-api-key" },
          endpoint = "https://api.deepseek.com",
          model = "deepseek-coder",
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
