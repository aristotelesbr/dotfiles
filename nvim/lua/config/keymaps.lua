-- Default options
local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --

-- Remap space as leader key
keymap("n", "<leader>sl", ":set spell!<CR>", { desc = "Toggle spelling" })

-- Delete line without yanking
keymap("n", "<Leader>dd", '"_dd', opts)

-- Open floating diagnostics
keymap("n", "<Leader>of", ":lua vim.diagnostic.open_float(nil, {focus=false})<CR>", opts)

-- Reload configs
keymap("n", "<Leader>rr", ":luafile %<CR>", opts)

-- Resize with arrows (C-Up/C-Down/C-h/j/k/l/S-h/l/A-j/k left to LazyVim's own defaults)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Move to start and end of line
keymap("n", "<A-h>", "^", opts)
keymap("n", "<A-l>", "$", opts)

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Jump to start of line using ESC + h or ESC + l
keymap("i", "<Esc>h", "<C-o>^", opts)
keymap("i", "<Esc>l", "<C-o>$", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

