-- colorscheme instaled
-- local colorscheme = "vividchalk"

-- local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
-- if not status_ok then
--   return
-- end

-- local colorscheme = "tokyonight-moon"
--
-- local status_ok, _ pcall(vim.cmd, "colorscheme " .. colorscheme)
-- if not status_ok then
--   return
-- end

-- local colorscheme = "base16-standardized-light"
-- local colorscheme = "rose-pine-dawn"
-- local colorscheme = "monokai"
-- local colorscheme = "soda.nvim"
local colorscheme = "github_light"

local status_ok, _
pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end
