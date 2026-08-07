-- Override LazyVim's H/L buffer navigation: scroll viewport, then screen H/L.
-- Buffer prev/next remains on [b / ]b.
vim.keymap.set("n", "L", "<C-E><C-E><C-E>L", { desc = "Scroll down" })
vim.keymap.set("n", "H", "<C-Y><C-Y><C-Y>H", { desc = "Scroll up" })
