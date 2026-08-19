-- Markdown tweaks on top of LazyVim's lang.markdown extra.
return {
  -- Disable in-buffer styled rendering from LazyVim's markdown extra.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
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
