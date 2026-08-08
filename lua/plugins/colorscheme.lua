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
      -- VS Code–style neutral greys; keep base > mantle > crust so buffer / explorer / terminal stay distinct.
      color_overrides = {
        mocha = {
          base = "#1e1e1e", -- editor (VS Code Dark+)
          mantle = "#181818", -- explorer / side panels
          crust = "#141414", -- terminal / deepest chrome
        },
      },
    },
  },
}
