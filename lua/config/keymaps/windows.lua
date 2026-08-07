-- Window navigation: Option/Alt+hjkl instead of Ctrl+hjkl
-- (overrides LazyVim move-line maps on <A-j>/<A-k> in normal mode)
for _, key in ipairs({ "h", "j", "k", "l" }) do
  pcall(vim.keymap.del, "n", "<C-" .. key .. ">")
end
pcall(vim.keymap.del, "n", "<A-j>")
pcall(vim.keymap.del, "n", "<A-k>")
pcall(vim.keymap.del, "i", "<A-j>")
pcall(vim.keymap.del, "i", "<A-k>")
pcall(vim.keymap.del, "v", "<A-j>")
pcall(vim.keymap.del, "v", "<A-k>")

vim.keymap.set({ "n", "t" }, "<A-h>", "<Cmd>wincmd h<CR>", { desc = "Go to Left Window" })
vim.keymap.set({ "n", "t" }, "<A-j>", "<Cmd>wincmd j<CR>", { desc = "Go to Lower Window" })
vim.keymap.set({ "n", "t" }, "<A-k>", "<Cmd>wincmd k<CR>", { desc = "Go to Upper Window" })
vim.keymap.set({ "n", "t" }, "<A-l>", "<Cmd>wincmd l<CR>", { desc = "Go to Right Window" })

-- Cmd+\ → split window right
vim.keymap.set({ "n", "i", "v", "t" }, "<D-\\>", "<C-w>v", { desc = "Split Window Right" })

-- Cmd+G → close current window; if last window, close all buffers
vim.keymap.set({ "n", "i", "v", "t" }, "<D-g>", function()
  if #vim.api.nvim_tabpage_list_wins(0) > 1 then
    vim.cmd.close()
  else
    Snacks.bufdelete.all()
  end
end, { desc = "Close Window or All Buffers" })
