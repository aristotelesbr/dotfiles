
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

-- local colorscheme = "github_dark"

local colorscheme = "github_dark_high_contrast"

-- local status_ok, _ pcall(vim.cmd, "colorscheme " .. colorscheme)
-- if not status_ok then
--   return
-- end
--

local status_ok, _ pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end

