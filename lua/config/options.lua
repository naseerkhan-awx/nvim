-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Keep some padding like VS Code
vim.opt.scrolloff = 5

-- Keep the terminal tab title fixed to the session's starting target.
require("config.session_title").apply()
