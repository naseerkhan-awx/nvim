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

-- Cmd+/ → toggle comments on the selected lines
vim.keymap.set("x", "<D-/>", "gc", { remap = true, desc = "Toggle Comment" })

-- Cmd+G → close current window; if last window, close all buffers
vim.keymap.set({ "n", "i", "v", "t" }, "<D-g>", function()
  if #vim.api.nvim_tabpage_list_wins(0) > 1 then
    vim.cmd.close()
  else
    Snacks.bufdelete.all()
  end
end, { desc = "Close Window or All Buffers" })

-- Cmd+J → focus terminal below (root dir)
vim.keymap.set({ "n", "t" }, "<D-j>", function()
  Snacks.terminal.focus(nil, {
    cwd = LazyVim.root.git(),
    auto_insert = true,
    env = { SNACKS_TERM = "bottom" },
    win = { position = "bottom", height = 0.3 },
  })
end, { desc = "Terminal (Root Dir)" })

-- Cmd+I → focus terminal on the right (separate from Cmd+J)
vim.keymap.set({ "n", "t" }, "<D-i>", function()
  Snacks.terminal.focus("agent", {
    cwd = LazyVim.root.git(),
    auto_insert = false,
    env = { SNACKS_TERM = "right" }, -- distinct id from bottom terminal
    win = { position = "right", width = 0.3 },
  })
end, { desc = "Terminal Right (Root Dir)" })

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

-- Cmd+B → focus file explorer (root dir)
vim.keymap.set({ "n", "t" }, "<D-b>", function()
  focus_explorer({ cwd = LazyVim.root.git() })
end, { desc = "Explorer Snacks (root dir)" })

-- In terminal normal mode, n → create a new tmux window.
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(args)
    vim.keymap.set("n", "n", function()
      vim.fn.jobstart({ "tmux", "new-window" }, { detach = true })
    end, { buffer = args.buf, desc = "Tmux New Window" })
    vim.keymap.set({ "n", "t" }, "<D-w>", function()
      vim.fn.jobstart({ "tmux", "kill-window" }, { detach = true })
    end, { buffer = args.buf, desc = "Tmux Kill Window" })
    vim.keymap.set({ "n", "t" }, "<M-H>", function()
      vim.fn.jobstart({ "tmux", "select-window", "-t", ":-1" }, { detach = true })
    end, { buffer = args.buf, desc = "Tmux Previous Window" })
    vim.keymap.set({ "n", "t" }, "<M-L>", function()
      vim.fn.jobstart({ "tmux", "select-window", "-t", ":+1" }, { detach = true })
    end, { buffer = args.buf, desc = "Tmux Next Window" })
  end,
})
