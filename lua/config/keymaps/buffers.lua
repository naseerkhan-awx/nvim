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
