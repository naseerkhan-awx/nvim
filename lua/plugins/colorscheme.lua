return {
  -- LazyVim already vendors catppuccin; enable Mocha as the default theme.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    "catppuccin/nvim",
    opts = {
      flavour = "mocha",
    },
  },
}
