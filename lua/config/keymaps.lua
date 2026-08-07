-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- Override LazyVim's H/L buffer navigation: scroll viewport, then screen H/L.
-- Buffer prev/next remains on [b / ]b.
vim.keymap.set("n", "L", "<C-E><C-E><C-E>L", { desc = "Scroll down" })
vim.keymap.set("n", "H", "<C-Y><C-Y><C-Y>H", { desc = "Scroll up" })

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

-- Focus panel if open but unfocused; close if focused; otherwise open.
local function focus_explorer(opts)
  local explorer = Snacks.picker.get({ source = "explorer" })[1]
  if explorer then
    if explorer:is_focused() then
      explorer:close()
    else
      explorer:focus()
    end
  else
    Snacks.explorer(opts)
  end
end

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

-- Cmd+B → focus file explorer (root dir)
vim.keymap.set({ "n", "t" }, "<D-b>", function()
  focus_explorer({ cwd = LazyVim.root.git() })
end, { desc = "Explorer Snacks (root dir)" })

-- Cmd+P → find files (same as <leader><space>)
vim.keymap.set({ "n", "i", "v", "t" }, "<D-p>", LazyVim.pick("files"), { desc = "Find Files (Root Dir)" })

-- Cmd+W → close current buffer (keep window layout)
vim.keymap.set({ "n", "i", "v", "t" }, "<D-w>", function()
  Snacks.bufdelete()
end, { desc = "Close Buffer" })

-- Cmd+G → close all buffers
vim.keymap.set({ "n", "i", "v", "t" }, "<D-g>", function()
  Snacks.bufdelete.all()
end, { desc = "Close All Buffers" })

-- Cmd+D → go to implementations (same as gI)
vim.keymap.set({ "n", "i", "v" }, "<D-d>", function()
  if Snacks and Snacks.picker and Snacks.picker.lsp_implementations then
    Snacks.picker.lsp_implementations()
  else
    vim.lsp.buf.implementation()
  end
end, { desc = "Goto Implementation" })

-- Cmd+S → save file (same as Ctrl+S)
vim.keymap.set({ "n", "i", "v", "s" }, "<D-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Cmd+[ / Cmd+] → jumplist back / forward (like IDE navigate back/forward)
vim.keymap.set({ "n", "i", "v" }, "<D-[>", function()
  vim.cmd.normal({ vim.api.nvim_replace_termcodes("<C-o>", true, false, true), bang = true })
end, { desc = "Jump Back" })
vim.keymap.set({ "n", "i", "v" }, "<D-]>", function()
  vim.cmd.normal({ vim.api.nvim_replace_termcodes("<C-i>", true, false, true), bang = true })
end, { desc = "Jump Forward" })
