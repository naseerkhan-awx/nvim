-- Paste over a visual selection without clobbering the register/clipboard.
-- Vim deletes the selection into a register on paste-over; deleting into the
-- black hole register ("_) instead keeps the original paste text intact, so
-- repeated pastes and the system clipboard stay untouched.
vim.keymap.set("x", "p", '"_dP', { desc = "Paste (keep register)" })
vim.keymap.set("x", "P", '"_dP', { desc = "Paste (keep register)" })
