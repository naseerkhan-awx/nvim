-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Cmd+J → toggle terminal below (root dir)
vim.keymap.set({ "n", "t" }, "<D-j>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root(), auto_insert = false })
end, { desc = "Terminal (Root Dir)" })

-- Cmd+I → toggle terminal on the right (separate from Cmd+J)
vim.keymap.set({ "n", "t" }, "<D-i>", function()
  Snacks.terminal(nil, {
    cwd = LazyVim.root(),
    auto_insert = false,
    env = { SNACKS_TERM = "right" }, -- distinct id from bottom terminal
    win = { position = "right", width = 0.4 },
  })
end, { desc = "Terminal Right (Root Dir)" })

-- Cmd+B → toggle file explorer (root dir)
vim.keymap.set({ "n", "t" }, "<D-b>", function()
  Snacks.explorer({ cwd = LazyVim.root() })
end, { desc = "Explorer Snacks (root dir)" })
