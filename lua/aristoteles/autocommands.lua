-- _general_settings
local general_settings_group = vim.api.nvim_create_augroup("_general_settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = general_settings_group,
  pattern = "qf,help,man,lspinfo",
  command = "nnoremap <silent> <buffer> q :close<CR>"
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = general_settings_group,
  pattern = "*",
  command = "silent! lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})"
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = general_settings_group,
  pattern = "*",
  command = ":set formatoptions-=cro"
})

vim.api.nvim_create_autocmd("FileType", {
  group = general_settings_group,
  pattern = "qf",
  command = "set nobuflisted"
})

vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"},{
  group = general_settings_group,
  pattern = "*",
  command = "lua vim.diagnostic.open_float(nil, {focus=false})"
})

-- _git
local git_group = vim.api.nvim_create_augroup("_git", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = git_group,
  pattern = "gitcommit",
  command = "setlocal wrap"
})

vim.api.nvim_create_autocmd("FileType", {
  group = git_group,
  pattern = "gitcommit",
  command = "setlocal spell"
})

-- _markdown
local markdown_group = vim.api.nvim_create_augroup("_markdown", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = markdown_group,
  pattern = "markdown",
  command = "setlocal wrap"
})

vim.api.nvim_create_autocmd("FileType", {
  group = markdown_group,
  pattern = "markdown",
  command = "setlocal spell"
})

-- _auto_resize
local auto_resize_group = vim.api.nvim_create_augroup("_auto_resize", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
  group = auto_resize_group,
  command = "tabdo wincmd ="
})

-- _alpha
local alpha_group = vim.api.nvim_create_augroup("_alpha", { clear = true })

vim.api.nvim_command("augroup " .. alpha_group)
vim.api.nvim_command("autocmd!")
vim.api.nvim_command("autocmd User AlphaReady lua vim.api.nvim_set_option('showtabline', 0)")
vim.api.nvim_command("autocmd BufUnload <buffer> lua vim.api.nvim_set_option('showtabline', 2)")
vim.api.nvim_command("augroup END")

-- _copilot
local copilot_group = vim.api.nvim_create_augroup("_copilot", { clear = true })
--
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = copilot_group,
  pattern = "*",
  command = "Copilot suggestion",
})


