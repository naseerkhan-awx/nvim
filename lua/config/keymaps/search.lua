-- Cmd+P → find files (same as <leader><space>)
vim.keymap.set(
  { "n", "i", "v", "t" },
  "<D-p>",
  LazyVim.pick("files", { hidden = true }),
  { desc = "Find Files (Root Dir)" }
)

-- Cmd+K → fuzzy git branch finder / switcher (same as <leader>gb)
vim.keymap.set({ "n", "i", "v", "t" }, "<D-k>", function()
  Snacks.picker.git_branches({ all = true })
end, { desc = "Git Branches" })

-- Cmd+Shift+R → projects (same as <leader>fp)
vim.keymap.set({ "n", "i", "v", "t" }, "<D-S-r>", function()
  Snacks.picker.projects()
end, { desc = "Projects" })

-- Cmd+D → go to implementations (same as gI)
vim.keymap.set({ "n", "i", "v" }, "<D-d>", function()
  if Snacks and Snacks.picker and Snacks.picker.lsp_implementations then
    Snacks.picker.lsp_implementations()
  else
    vim.lsp.buf.implementation()
  end
end, { desc = "Goto Implementation" })

-- Cmd+[ / Cmd+] → jumplist back / forward (like IDE navigate back/forward)
vim.keymap.set({ "n", "i", "v" }, "<D-[>", function()
  vim.cmd.normal({ vim.api.nvim_replace_termcodes("<C-o>", true, false, true), bang = true })
end, { desc = "Jump Back" })
vim.keymap.set({ "n", "i", "v" }, "<D-]>", function()
  vim.cmd.normal({ vim.api.nvim_replace_termcodes("<C-i>", true, false, true), bang = true })
end, { desc = "Jump Forward" })
