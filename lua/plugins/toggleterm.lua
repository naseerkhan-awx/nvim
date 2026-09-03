return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      -- Keymaps live in lua/config/keymaps/ui.lua; do not steal <C-\>.
      open_mapping = nil,
      shade_terminals = false,
      start_in_insert = true,
      -- Off by default: in normal mode toggleterm scrolls to bottom on every line of
      -- output (e.g. Gradle bootRun), which fights reading logs.
      auto_scroll = false,
      persist_mode = true,
      persist_size = false,
      direction = "horizontal",
      close_on_exit = false,
      highlights = {
        Normal = { guibg = "#141414" },
      },
      size = function(term)
        if term.direction == "horizontal" then
          return math.max(5, math.floor(vim.o.lines * 0.3))
        end
        return math.max(20, math.floor(vim.o.columns * 0.3))
      end,
      on_create = function(term)
        require("config.term").attach(term)
      end,
    },
  },
}
