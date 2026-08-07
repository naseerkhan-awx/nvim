-- Markdown tweaks on top of LazyVim's lang.markdown extra.
return {
  -- Restore heading icons/backgrounds (LazyVim sets icons = {}).
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = {
        sign = false,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "block",
        left_pad = 1,
        right_pad = 1,
      },
      checkbox = {
        enabled = true,
      },
    },
  },

  -- Turn off markdownlint diagnostics (MD013 line length, etc.).
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
}
