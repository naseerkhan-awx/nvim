-- Cmd+D → go to implementations (same as gI)
vim.keymap.set({ "n", "i", "v" }, "<D-d>", function()
  if Snacks and Snacks.picker and Snacks.picker.lsp_implementations then
    Snacks.picker.lsp_implementations()
  else
    vim.lsp.buf.implementation()
  end
end, { desc = "Goto Implementation" })
