local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("n", "<C-h>", "<C-w><C-h>", { desc = "Window left" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Window right" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Window down" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Window up" })

map("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })
map("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
map("n", "[b", ":bprevious<CR>", { desc = "Prev buffer" })

map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
