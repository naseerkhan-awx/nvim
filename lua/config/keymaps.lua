-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here (split by category under lua/config/keymaps/)

require("config.keymaps.scroll")
require("config.keymaps.windows")
require("config.keymaps.terminals")
require("config.keymaps.explorer")
require("config.keymaps.buffers")
require("config.keymaps.pickers")
require("config.keymaps.lsp")
require("config.keymaps.editing")
require("config.keymaps.navigation")
