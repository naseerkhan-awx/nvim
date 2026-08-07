-- Cmd+J → focus terminal below (root dir)
vim.keymap.set({ "n", "t" }, "<D-j>", function()
  Snacks.terminal.focus(nil, { cwd = LazyVim.root.git(), auto_insert = false })
end, { desc = "Terminal (Root Dir)" })

-- Cmd+I → focus terminal on the right (separate from Cmd+J)
vim.keymap.set({ "n", "t" }, "<D-i>", function()
  Snacks.terminal.focus(nil, {
    cwd = LazyVim.root.git(),
    auto_insert = false,
    env = { SNACKS_TERM = "right" }, -- distinct id from bottom terminal
    win = { position = "right", width = 0.4 },
  })
end, { desc = "Terminal Right (Root Dir)" })
