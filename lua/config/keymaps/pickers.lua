-- Cmd+P → find files (same as <leader><space>)
vim.keymap.set(
  { "n", "i", "v", "t" },
  "<D-p>",
  LazyVim.pick("files", { hidden = true }),
  { desc = "Find Files (Root Dir)" }
)

-- Cmd+K → fuzzy git branch finder / switcher (same as <leader>gb)
vim.keymap.set({ "n", "i", "v", "t" }, "<D-k>", function()
  Snacks.picker.git_branches()
end, { desc = "Git Branches" })
