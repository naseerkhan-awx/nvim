-- Override LazyVim's H/L buffer navigation: scroll viewport, then screen H/L.
-- Buffer prev/next remains on [b / ]b.
vim.keymap.set("n", "L", "<C-E><C-E><C-E>L", { desc = "Scroll down" })
vim.keymap.set("n", "H", "<C-Y><C-Y><C-Y>H", { desc = "Scroll up" })

-- Cmd+W → close current buffer (keep window layout)
vim.keymap.set({ "n", "i", "v", "t" }, "<D-w>", function()
  Snacks.bufdelete()
end, { desc = "Close Buffer" })

-- Cmd+Shift+[ / ] → previous / next buffer
-- macOS often reports these as <D-{> / <D-}>, so bind both forms.
local modes = { "n", "i", "v", "t" }
for _, key in ipairs({ "<D-S-[>", "<D-{" }) do
  vim.keymap.set(modes, key, "<Cmd>bprevious<CR>", { desc = "Prev Buffer" })
end
for _, key in ipairs({ "<D-S-]>", "<D-}" }) do
  vim.keymap.set(modes, key, "<Cmd>bnext<CR>", { desc = "Next Buffer" })
end

-- Cmd+S → save file (same as Ctrl+S)
vim.keymap.set({ "n", "i", "v", "s" }, "<D-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
