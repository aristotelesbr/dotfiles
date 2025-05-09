-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
local general_settings_group = vim.api.nvim_create_augroup("_general_settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = general_settings_group,
  pattern = "qf,help,man,lspinfo",
  command = "nnoremap <silent> <buffer> q :close<CR>",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = general_settings_group,
  pattern = "*",
  command = "silent! lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = general_settings_group,
  pattern = "*",
  command = ":set formatoptions-=cro",
})

vim.api.nvim_create_autocmd("FileType", {
  group = general_settings_group,
  pattern = "qf",
  command = "set nobuflisted",
})

-- _git
local git_group = vim.api.nvim_create_augroup("_git", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = git_group,
  pattern = "gitcommit",
  command = "setlocal wrap",
})

vim.api.nvim_create_autocmd("FileType", {
  group = git_group,
  pattern = "gitcommit",
  command = "setlocal spell",
})

-- _markdown
local markdown_group = vim.api.nvim_create_augroup("_markdown", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = markdown_group,
  pattern = "markdown",
  command = "setlocal wrap",
})

vim.api.nvim_create_autocmd("FileType", {
  group = markdown_group,
  pattern = "markdown",
  command = "setlocal spell",
})

-- _auto_resize
local auto_resize_group = vim.api.nvim_create_augroup("_auto_resize", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
  group = auto_resize_group,
  command = "tabdo wincmd =",
})

-- _alpha
local alpha_group = vim.api.nvim_create_augroup("_alpha", { clear = true })

vim.api.nvim_command("augroup " .. alpha_group)
vim.api.nvim_command("autocmd!")
vim.api.nvim_command("autocmd User AlphaReady lua vim.api.nvim_set_option('showtabline', 0)")
vim.api.nvim_command("autocmd BufUnload <buffer> lua vim.api.nvim_set_option('showtabline', 2)")
vim.api.nvim_command("augroup END")

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.heex", "*.svg" },
  command = "set filetype=html",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})
