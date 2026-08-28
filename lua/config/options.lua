-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Keep some padding like VS Code
vim.opt.scrolloff = 5

-- Keep the terminal tab title fixed to the session's starting target.
local session_title = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
if vim.fn.argc() == 1 then
  local target = vim.fn.argv(0)
  if vim.fn.isdirectory(target) == 0 then
    session_title = vim.fn.fnamemodify(target, ":t")
  end
end

vim.opt.title = true
vim.opt.titlestring = session_title
