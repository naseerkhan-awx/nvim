-- Cmd+P → find files from the git project root (not LSP workspace root).
-- Respects gitignore, but always includes .env* (often gitignored).
vim.keymap.set({ "n", "i", "v", "t" }, "<D-p>", function()
  local cwd = LazyVim.root.git()
  Snacks.picker({
    cwd = cwd,
    format = "file",
    transform = "unique_file",
    hidden = true,
    multi = {
      { source = "files", hidden = true, ignored = false, cwd = cwd },
      {
        source = "files",
        hidden = true,
        ignored = true,
        cwd = cwd,
        args = { "--glob", ".env*" },
      },
    },
  })
end, { desc = "Find Files (Root Dir)" })

-- Cmd+Shift+P → search open buffers (same as <leader>,)
vim.keymap.set({ "n", "i", "v", "t" }, "<D-S-p>", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

-- Cmd+Shift+F → global text search (same as <leader>/)
vim.keymap.set({ "n", "i", "v", "t" }, "<D-S-f>", LazyVim.pick("live_grep"), { desc = "Grep (Root Dir)" })

-- Cmd+K → fuzzy git branch finder / switcher (same as <leader>gb)
vim.keymap.set({ "n", "i", "v", "t" }, "<D-k>", function()
  Snacks.picker.git_branches({ all = true })
end, { desc = "Git Branches" })

-- Cmd+Shift+R → work projects
vim.keymap.set({ "n", "i", "v", "t" }, "<D-S-r>", function()
  Snacks.picker.work_projects()
end, { desc = "Work Projects" })

-- Cmd+Shift+O → LSP symbols in current file (same as <leader>ss)
vim.keymap.set({ "n", "i", "v" }, "<D-S-o>", function()
  Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter })
end, { desc = "LSP Symbols" })

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
