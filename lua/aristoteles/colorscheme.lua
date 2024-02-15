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

local colorscheme = "rose-pine-dawn"
-- local colorscheme = "github_light_colorblind"

local status_ok, _
pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end
