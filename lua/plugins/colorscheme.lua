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
      -- Darker Mocha layers; keep base > mantle > crust so buffer / explorer / terminal stay distinct.
      color_overrides = {
        mocha = {
          base = "#0f0f17", -- editor
          mantle = "#0a0a10", -- explorer / side panels
          crust = "#050508", -- terminal / deepest chrome
        },
      },
    },
  },
}
