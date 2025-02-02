local options = {
  hidden = true,
  backup = false,
  clipboard = "unnamed",
  cmdheight = 2,
  completeopt = { "menuone", "noselect" },
  conceallevel = 0,
  fileencoding = "utf-8",
  hlsearch = true,
  ignorecase = true,
  mouse = "a",
  pumheight = 10,
  showmode = false,
  smartcase = true,
  smartindent = true,
  splitbelow = true,
  splitright = true,
  swapfile = false,
  timeoutlen = 300,
  undofile = true,
  updatetime = 300,
  writebackup = false,
  shiftwidth = 2,
  tabstop = 2,
  softtabstop = 2,
  expandtab = true,
  cursorline = true,

  number = true,
  relativenumber = false,
  numberwidth = 4,
  autoindent = true,

  signcolumn = "yes",
  wrap = true,
  linebreak = true,
  scrolloff = 8,
  sidescrolloff = 8,
  guifont = "monospace:h17",
  whichwrap = "bs<>[]hl",
  colorcolumn = "80",
  background = "dark",
  list = true,
  listchars = { tab = "▸\\", trail = "·", extends = "→", nbsp = "␣" },
  foldmethod = "indent",
  foldlevelstart = 99,
  autoread = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
