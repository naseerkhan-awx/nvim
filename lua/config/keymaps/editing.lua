-- Cmd+S → save file (same as Ctrl+S)
vim.keymap.set({ "n", "i", "v", "s" }, "<D-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
