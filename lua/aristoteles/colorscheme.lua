-- colorscheme instaled

-- local colorscheme = "tokyonight-moon"
-- local colorscheme = "vividchalk"
-- local colorscheme = "base16-standardized-light"
-- local colorscheme = "rose-pine-dawn"
-- local colorscheme = "monokai"
-- local colorscheme = "soda.nvim"
-- local colorscheme = "tokyonight"
local colorscheme = "catppuccin"
-- local colorscheme = "github_light"

local status_ok, _
pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end
