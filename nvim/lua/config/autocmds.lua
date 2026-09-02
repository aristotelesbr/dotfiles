-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
local general_settings_group = vim.api.nvim_create_augroup("_general_settings", { clear = true })

-- LazyVim's close_with_q already covers qf/help/lspinfo/etc; man isn't in that list
vim.api.nvim_create_autocmd("FileType", {
  group = general_settings_group,
  pattern = "man",
  command = "nnoremap <silent> <buffer> q :close<CR>",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = general_settings_group,
  pattern = "*",
  command = ":set formatoptions-=cro",
})

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

-- Neovim's autoread defaults to off; LazyVim's own checktime autocmd only
-- flips the buffer if autoread is on, so this still needs to be set explicitly.
vim.opt.autoread = true
