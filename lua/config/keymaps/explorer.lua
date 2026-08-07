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
